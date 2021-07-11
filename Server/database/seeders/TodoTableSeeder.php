<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Tododata;

class TodoTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $param = [
            'title' => 'test1',
            'is_complete' => 'false',
        ];

        $tododata = new Tododata;
        $tododata->fill($param)->save();

        $param = [
            'title' => 'test2',
            'is_complete' => 'false',
        ];

        $tododata = new Tododata;
        $tododata->fill($param)->save();

        $param = [
            'title' => 'test3',
            'is_complete' => 'false',
        ];

        $tododata = new Tododata;
        $tododata->fill($param)->save();
    }
}
