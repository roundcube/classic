#!/usr/bin/env php
<?php

foreach (get_files(__DIR__ . '/..') as $file) {
    print "Processing $file\n";

    $content = file_get_contents($file);
    $regexp  = "#url\(['\"]?([a-zA-Z0-9_./-]+)(\?v=[a-f0-9-\.]+)?['\"]?\)#";

    if (preg_match_all($regexp, $content, $matches)) {
        $seen = [];

        foreach ($matches[1] as $idx => $image) {
            if (!in_array($image, $seen) && preg_match('/\.(gif|ico|png|jpg|jpeg)$/', $image)) {
                $filepath = pathinfo($file, PATHINFO_DIRNAME) . "/$image";

                if (file_exists($filepath)) {
                    $sum = substr(md5_file($filepath), 0, 4) . '.' . filesize($filepath);
                }
                else {
                    print "ERROR: Missing image: $filepath\n";
                    continue;
                }

                $content = str_replace($matches[0][$idx], "url($image?v=$sum)", $content);
            }

            $seen[] = $image;
        }

        file_put_contents($file, $content);
    }
}


function get_files($dir)
{
    $files = [];
    $dh    = opendir($dir);

    while ($file = readdir($dh)) {
        if (preg_match('/^(.+)\.min\.css$/', $file, $m)) {
            $files[] = "$dir/$file";
        }
        else if ($file[0] != '.' && is_dir("$dir/$file")) {
            foreach (get_files("$dir/$file") as $f) {
                $files[] = $f;
            }
        }
    }

    closedir($dh);

    return $files;
}
