Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0EXDDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 23:03:16 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:47423 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755916Ab0EXDDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 23:03:14 -0400
Message-ID: <4BF9EC69.5030709@example.com>
Date: Mon, 24 May 2010 05:03:05 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
Content-Type: multipart/mixed;
 boundary="------------020107070507000301080008"
X-Ovh-Tracer-Id: 17036272966368850200
X-Ovh-Remote: 83.6.189.33 (abaz33.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020107070507000301080008
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I had this error in linux-next and reported it, but nobody answered :-( 
Now it's here, in fresh git source built kernel. After I boot the screen 
becomes cluttered with messages as in subject line. I attach dmesg and 
cpuinfo.

Regards,

Piotr Hosowicz

-- 
TV: "Filimonow jest cudownie miêkki, wspaniale pracuje udami."
NP: Slash - Paradise City (Feat. Fergie And Cypress Hill) (Australian Bonus)
NB: 2.6.34-20100524-0407

--------------020107070507000301080008
Content-Type: text/plain;
 name="cpuinfo.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cpuinfo.txt"

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz
stepping	: 7
cpu MHz		: 2333.377
cache size	: 2048 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm
bogomips	: 4666.75
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz
stepping	: 7
cpu MHz		: 2333.377
cache size	: 2048 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm
bogomips	: 4666.11
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz
stepping	: 7
cpu MHz		: 2333.377
cache size	: 2048 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm
bogomips	: 4677.65
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz
stepping	: 7
cpu MHz		: 2333.377
cache size	: 2048 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm
bogomips	: 4666.09
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


--------------020107070507000301080008
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

t+0x1bf/0x2c7
[  720.313420]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  720.313426]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  720.313430]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  720.313435]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  720.313440]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  720.313447]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  720.313458]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  720.313462]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  720.313466]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  720.313472]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  720.313476]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  720.313480]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  720.313485]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  720.313496]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  720.313507]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  720.313521]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  720.313526]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  720.313533]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  720.313537]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  720.313541]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  720.313547]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  720.313551]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  720.313555]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  720.313563]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  720.313567]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  720.313574]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  720.313579]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  720.313583]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  720.313588]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  720.313593]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  720.313607] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  720.313612] caller is native_sched_clock+0x3c/0x68
[  720.313616] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  720.313618] Call Trace:
[  720.313624]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  720.313629]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  720.313634]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  720.313637]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  720.313641]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  720.313646]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  720.313651]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  720.313656]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  720.313661]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  720.313666]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  720.313672]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  720.313684]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  720.313689]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  720.313693]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  720.313698]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  720.313702]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  720.313707]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  720.313712]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  720.313723]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  720.313734]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  720.313748]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  720.313752]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  720.313758]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  720.313763]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  720.313767]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  720.313773]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  720.313778]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  720.313783]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  720.313790]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  720.313794]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  720.313801]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  720.313806]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  720.313810]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  720.313814]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  720.313819]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  727.343086] debug_smp_processor_id: 469 callbacks suppressed
[  727.343090] BUG: using smp_processor_id() in preemptible [00000000] code: mocp/5600
[  727.343097] caller is native_sched_clock+0x3c/0x68
[  727.343101] Pid: 5600, comm: mocp Tainted: P            2.6.34-20100524-0407 #1
[  727.343103] Call Trace:
[  727.343111]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  727.343114]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  727.343118]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  727.343121]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  727.343125]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  727.343128]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  727.343133]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  727.343135]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  727.343139]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  727.343142]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  727.343146]  [<ffffffff81114f03>] ? do_mpage_readpage+0x3c9/0x47e
[  727.343150]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  727.343153]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  727.343156]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  727.343159]  [<ffffffff8111511c>] mpage_readpages+0x107/0x11b
[  727.343184]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  727.343194]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  727.343204]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  727.343208]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  727.343211]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  727.343214]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  727.343218]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  727.343221]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  727.343225]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  727.343229]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  727.343233]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  727.343237]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  727.343241]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  727.343244]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  727.343247]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  727.343250]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  727.343254]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  727.344496] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  727.344501] caller is native_sched_clock+0x3c/0x68
[  727.344503] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  727.344505] Call Trace:
[  727.344510]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  727.344514]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  727.344517]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  727.344520]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  727.344523]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  727.344526]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  727.344530]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  727.344533]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  727.344536]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  727.344539]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  727.344542]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  727.344546]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  727.344550]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  727.344554]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  727.344557]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  727.344572]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  727.344576]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.344579]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.344589]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  727.344593]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  727.344596]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  727.344606]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  727.344609]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  727.344613]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  727.344616]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  727.344620]  [<ffffffff81039c4c>] ? update_curr+0x104/0x10d
[  727.344623]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  727.344626]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  727.344634]  [<ffffffffa0155320>] journal_submit_data_buffers+0x104/0x171 [jbd2]
[  727.344641]  [<ffffffffa0155a00>] jbd2_journal_commit_transaction+0x4a8/0x14c4 [jbd2]
[  727.344646]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  727.344650]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  727.344658]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  727.344661]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  727.344669]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  727.344672]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  727.344675]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  727.344678]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  727.344681]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  727.344701] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  727.344705] caller is native_sched_clock+0x3c/0x68
[  727.344707] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  727.344709] Call Trace:
[  727.344713]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  727.344716]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  727.344719]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  727.344722]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  727.344725]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  727.344729]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  727.344733]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  727.344736]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  727.344740]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  727.344743]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  727.344747]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  727.344751]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  727.344754]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  727.344764]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  727.344768]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.344771]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.344781]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  727.344785]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  727.344788]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  727.344798]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  727.344801]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  727.344805]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  727.344808]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  727.344811]  [<ffffffff81039c4c>] ? update_curr+0x104/0x10d
[  727.344814]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  727.344818]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  727.344824]  [<ffffffffa0155320>] journal_submit_data_buffers+0x104/0x171 [jbd2]
[  727.344832]  [<ffffffffa0155a00>] jbd2_journal_commit_transaction+0x4a8/0x14c4 [jbd2]
[  727.344836]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  727.344839]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  727.344846]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  727.344850]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  727.344857]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  727.344860]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  727.344864]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  727.344867]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  727.344869]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  727.344898] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  727.344902] caller is native_sched_clock+0x3c/0x68
[  727.344904] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  727.344906] Call Trace:
[  727.344910]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  727.344913]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  727.344916]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  727.344919]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  727.344923]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  727.344926]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  727.344929]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  727.344933]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  727.344936]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  727.344939]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  727.344946]  [<ffffffffa0153277>] ? jbd_unlock_bh_state+0x13/0x2e [jbd2]
[  727.344950]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  727.344953]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  727.344960]  [<ffffffffa0155f44>] jbd2_journal_commit_transaction+0x9ec/0x14c4 [jbd2]
[  727.344964]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  727.344972]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  727.344975]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  727.344982]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  727.344986]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  727.344989]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  727.344992]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  727.344995]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  727.350885] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  727.350890] caller is native_sched_clock+0x3c/0x68
[  727.350893] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  727.350895] Call Trace:
[  727.350901]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  727.350905]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  727.350908]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  727.350912]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  727.350915]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  727.350918]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  727.350922]  [<ffffffff810b8293>] ? __alloc_pages_nodemask+0xf3/0x60c
[  727.350926]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  727.350929]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  727.350933]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  727.350936]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  727.350939]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  727.350943]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  727.350947]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  727.350956]  [<ffffffffa0155484>] journal_submit_commit_record+0xf7/0x16b [jbd2]
[  727.350963]  [<ffffffffa015638b>] jbd2_journal_commit_transaction+0xe33/0x14c4 [jbd2]
[  727.350968]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  727.350977]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  727.350980]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  727.350988]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  727.350991]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  727.350995]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  727.350998]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  727.351001]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  727.809030] BUG: using smp_processor_id() in preemptible [00000000] code: flush-8:0/2328
[  727.809038] caller is native_sched_clock+0x3c/0x68
[  727.809041] Pid: 2328, comm: flush-8:0 Tainted: P            2.6.34-20100524-0407 #1
[  727.809044] Call Trace:
[  727.809051]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  727.809055]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  727.809058]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  727.809062]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  727.809066]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  727.809069]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  727.809073]  [<ffffffff81183c9a>] ? generic_make_request+0x249/0x2be
[  727.809077]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  727.809081]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  727.809084]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  727.809088]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  727.809092]  [<ffffffff8119b147>] ? radix_tree_gang_lookup_tag_slot+0x84/0xa9
[  727.809096]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  727.809100]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  727.809104]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  727.809108]  [<ffffffff81111a39>] ? blkdev_get_block+0x0/0x5e
[  727.809111]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.809115]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.809118]  [<ffffffff81111a39>] ? blkdev_get_block+0x0/0x5e
[  727.809122]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  727.809125]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  727.809129]  [<ffffffff81112896>] blkdev_writepage+0x13/0x15
[  727.809133]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  727.809137]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  727.809140]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  727.809144]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  727.809147]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  727.809152]  [<ffffffff811077ac>] writeback_single_inode+0xde/0x300
[  727.809156]  [<ffffffff811080fb>] writeback_inodes_wb+0x429/0x530
[  727.809160]  [<ffffffff8110834b>] wb_writeback+0x149/0x1d0
[  727.809165]  [<ffffffff811085a3>] wb_do_writeback+0x1b9/0x1cf
[  727.809169]  [<ffffffff8104d043>] ? process_timeout+0x0/0xb
[  727.809173]  [<ffffffff811085f7>] bdi_writeback_task+0x3e/0x117
[  727.809177]  [<ffffffff8105a516>] ? bit_waitqueue+0x12/0xa4
[  727.809181]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  727.809185]  [<ffffffff810c6abf>] bdi_start_fn+0x71/0xd5
[  727.809188]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  727.809191]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  727.809195]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  727.809199]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  727.809202]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  727.809230] BUG: using smp_processor_id() in preemptible [00000000] code: flush-8:0/2328
[  727.809234] caller is native_sched_clock+0x3c/0x68
[  727.809236] Pid: 2328, comm: flush-8:0 Tainted: P            2.6.34-20100524-0407 #1
[  727.809238] Call Trace:
[  727.809242]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  727.809246]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  727.809249]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  727.809252]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  727.809255]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  727.809259]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  727.809263]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  727.809267]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  727.809270]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  727.809274]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  727.809278]  [<ffffffff8119b147>] ? radix_tree_gang_lookup_tag_slot+0x84/0xa9
[  727.809282]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  727.809285]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  727.809289]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  727.809292]  [<ffffffff81111a39>] ? blkdev_get_block+0x0/0x5e
[  727.809296]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.809299]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.809303]  [<ffffffff81111a39>] ? blkdev_get_block+0x0/0x5e
[  727.809306]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  727.809310]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  727.809314]  [<ffffffff81112896>] blkdev_writepage+0x13/0x15
[  727.809317]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  727.809320]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  727.809323]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  727.809328]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  727.809331]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  727.809335]  [<ffffffff811077ac>] writeback_single_inode+0xde/0x300
[  727.809338]  [<ffffffff811080fb>] writeback_inodes_wb+0x429/0x530
[  727.809342]  [<ffffffff8110834b>] wb_writeback+0x149/0x1d0
[  727.809347]  [<ffffffff811085a3>] wb_do_writeback+0x1b9/0x1cf
[  727.809350]  [<ffffffff8104d043>] ? process_timeout+0x0/0xb
[  727.809355]  [<ffffffff811085f7>] bdi_writeback_task+0x3e/0x117
[  727.809358]  [<ffffffff8105a516>] ? bit_waitqueue+0x12/0xa4
[  727.809362]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  727.809365]  [<ffffffff810c6abf>] bdi_start_fn+0x71/0xd5
[  727.809368]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  727.809371]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  727.809375]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  727.809378]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  727.809381]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  727.809388] BUG: using smp_processor_id() in preemptible [00000000] code: flush-8:0/2328
[  727.809391] caller is native_sched_clock+0x3c/0x68
[  727.809394] Pid: 2328, comm: flush-8:0 Tainted: P            2.6.34-20100524-0407 #1
[  727.809396] Call Trace:
[  727.809400]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  727.809403]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  727.809407]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  727.809409]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  727.809412]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  727.809416]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  727.809419]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  727.809423]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  727.809426]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  727.809430]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  727.809433]  [<ffffffff8119b147>] ? radix_tree_gang_lookup_tag_slot+0x84/0xa9
[  727.809437]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  727.809441]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  727.809444]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  727.809448]  [<ffffffff81111a39>] ? blkdev_get_block+0x0/0x5e
[  727.809451]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.809455]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.809459]  [<ffffffff81111a39>] ? blkdev_get_block+0x0/0x5e
[  727.809462]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  727.809466]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  727.809469]  [<ffffffff81112896>] blkdev_writepage+0x13/0x15
[  727.809472]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  727.809476]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  727.809479]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  727.809484]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  727.809487]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  727.809491]  [<ffffffff811077ac>] writeback_single_inode+0xde/0x300
[  727.809495]  [<ffffffff811080fb>] writeback_inodes_wb+0x429/0x530
[  727.809499]  [<ffffffff8110834b>] wb_writeback+0x149/0x1d0
[  727.809503]  [<ffffffff811085a3>] wb_do_writeback+0x1b9/0x1cf
[  727.809507]  [<ffffffff8104d043>] ? process_timeout+0x0/0xb
[  727.809511]  [<ffffffff811085f7>] bdi_writeback_task+0x3e/0x117
[  727.809514]  [<ffffffff8105a516>] ? bit_waitqueue+0x12/0xa4
[  727.809518]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  727.809521]  [<ffffffff810c6abf>] bdi_start_fn+0x71/0xd5
[  727.809524]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  727.809527]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  727.809531]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  727.809534]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  727.809537]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  727.809546] BUG: using smp_processor_id() in preemptible [00000000] code: flush-8:0/2328
[  727.809550] caller is native_sched_clock+0x3c/0x68
[  727.809552] Pid: 2328, comm: flush-8:0 Tainted: P            2.6.34-20100524-0407 #1
[  727.809554] Call Trace:
[  727.809558]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  727.809561]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  727.809565]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  727.809568]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  727.809571]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  727.809575]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  727.809579]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  727.809582]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  727.809586]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  727.809590]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  727.809593]  [<ffffffff8119b147>] ? radix_tree_gang_lookup_tag_slot+0x84/0xa9
[  727.809597]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  727.809600]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  727.809604]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  727.809607]  [<ffffffff81111a39>] ? blkdev_get_block+0x0/0x5e
[  727.809611]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.809614]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.809618]  [<ffffffff81111a39>] ? blkdev_get_block+0x0/0x5e
[  727.809621]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  727.809625]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  727.809629]  [<ffffffff81112896>] blkdev_writepage+0x13/0x15
[  727.809631]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  727.809635]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  727.809638]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  727.809642]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  727.809645]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  727.809649]  [<ffffffff811077ac>] writeback_single_inode+0xde/0x300
[  727.809653]  [<ffffffff811080fb>] writeback_inodes_wb+0x429/0x530
[  727.809657]  [<ffffffff8110834b>] wb_writeback+0x149/0x1d0
[  727.809661]  [<ffffffff811085a3>] wb_do_writeback+0x1b9/0x1cf
[  727.809664]  [<ffffffff8104d043>] ? process_timeout+0x0/0xb
[  727.809668]  [<ffffffff811085f7>] bdi_writeback_task+0x3e/0x117
[  727.809671]  [<ffffffff8105a516>] ? bit_waitqueue+0x12/0xa4
[  727.809675]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  727.809678]  [<ffffffff810c6abf>] bdi_start_fn+0x71/0xd5
[  727.809682]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  727.809685]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  727.809688]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  727.809691]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  727.809694]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  727.809789] BUG: using smp_processor_id() in preemptible [00000000] code: flush-8:0/2328
[  727.809793] caller is native_sched_clock+0x3c/0x68
[  727.809796] Pid: 2328, comm: flush-8:0 Tainted: P            2.6.34-20100524-0407 #1
[  727.809798] Call Trace:
[  727.809802]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  727.809805]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  727.809809]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  727.809811]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  727.809814]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  727.809818]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  727.809821]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  727.809825]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  727.809828]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  727.809832]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  727.809835]  [<ffffffff8119b147>] ? radix_tree_gang_lookup_tag_slot+0x84/0xa9
[  727.809839]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  727.809843]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  727.809847]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  727.809850]  [<ffffffff81111a39>] ? blkdev_get_block+0x0/0x5e
[  727.809854]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.809857]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  727.809861]  [<ffffffff81111a39>] ? blkdev_get_block+0x0/0x5e
[  727.809864]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  727.809868]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  727.809871]  [<ffffffff81112896>] blkdev_writepage+0x13/0x15
[  727.809875]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  727.809878]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  727.809881]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  727.809886]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  727.809889]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  727.809983]  [<ffffffff811077ac>] writeback_single_inode+0xde/0x300
[  727.809987]  [<ffffffff811080fb>] writeback_inodes_wb+0x429/0x530
[  727.809991]  [<ffffffff8110834b>] wb_writeback+0x149/0x1d0
[  727.809996]  [<ffffffff811085a3>] wb_do_writeback+0x1b9/0x1cf
[  727.810000]  [<ffffffff8104d043>] ? process_timeout+0x0/0xb
[  727.810003]  [<ffffffff811085f7>] bdi_writeback_task+0x3e/0x117
[  727.810007]  [<ffffffff8105a516>] ? bit_waitqueue+0x12/0xa4
[  727.810010]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  727.810014]  [<ffffffff810c6abf>] bdi_start_fn+0x71/0xd5
[  727.810016]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  727.810019]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  727.810023]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  727.810026]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  727.810030]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  732.509939] debug_smp_processor_id: 480 callbacks suppressed
[  732.509942] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  732.509949] caller is native_sched_clock+0x3c/0x68
[  732.509952] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  732.509954] Call Trace:
[  732.509961]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  732.509964]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  732.509967]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  732.509970]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  732.509973]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  732.509977]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  732.509981]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  732.509984]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  732.509987]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  732.509990]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  732.509993]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  732.510008]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  732.510012]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  732.510015]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  732.510019]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510022]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  732.510026]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  732.510029]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  732.510038]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510048]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510059]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  732.510062]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  732.510066]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  732.510069]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  732.510073]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  732.510076]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  732.510080]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  732.510084]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  732.510088]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  732.510091]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510095]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  732.510098]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  732.510101]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  732.510104]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  732.510108]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  732.510118] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  732.510121] caller is native_sched_clock+0x3c/0x68
[  732.510124] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  732.510125] Call Trace:
[  732.510129]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  732.510132]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  732.510135]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  732.510138]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  732.510140]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  732.510144]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  732.510147]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  732.510150]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  732.510153]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  732.510156]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  732.510160]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  732.510170]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  732.510173]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  732.510176]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  732.510179]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510182]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  732.510185]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  732.510188]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  732.510198]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510208]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510218]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  732.510221]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  732.510225]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  732.510228]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  732.510231]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  732.510234]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  732.510237]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  732.510241]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  732.510244]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  732.510247]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510251]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  732.510254]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  732.510257]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  732.510260]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  732.510263]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  732.510270] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  732.510273] caller is native_sched_clock+0x3c/0x68
[  732.510276] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  732.510278] Call Trace:
[  732.510281]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  732.510285]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  732.510288]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  732.510290]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  732.510293]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  732.510296]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  732.510300]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  732.510303]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  732.510306]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  732.510309]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  732.510313]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  732.510322]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  732.510326]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  732.510328]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  732.510332]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510335]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  732.510338]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  732.510341]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  732.510351]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510361]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510371]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  732.510374]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  732.510378]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  732.510381]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  732.510384]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  732.510387]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  732.510390]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  732.510393]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  732.510397]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  732.510400]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510404]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  732.510407]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  732.510410]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  732.510413]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  732.510416]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  732.510425] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  732.510428] caller is native_sched_clock+0x3c/0x68
[  732.510431] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  732.510432] Call Trace:
[  732.510436]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  732.510439]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  732.510442]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  732.510445]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  732.510447]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  732.510451]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  732.510454]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  732.510457]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  732.510460]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  732.510464]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  732.510467]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  732.510477]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  732.510480]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  732.510483]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  732.510486]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510489]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  732.510492]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  732.510495]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  732.510504]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510514]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510524]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  732.510528]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  732.510531]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  732.510534]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  732.510537]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  732.510541]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  732.510544]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  732.510547]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  732.510551]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  732.510554]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510558]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  732.510561]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  732.510564]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  732.510567]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  732.510570]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  732.510577] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  732.510580] caller is native_sched_clock+0x3c/0x68
[  732.510583] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  732.510584] Call Trace:
[  732.510588]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  732.510591]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  732.510594]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  732.510597]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  732.510599]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  732.510603]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  732.510606]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  732.510609]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  732.510612]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  732.510615]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  732.510619]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  732.510628]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  732.510631]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  732.510634]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  732.510638]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510640]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  732.510644]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  732.510647]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  732.510656]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510666]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510676]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  732.510679]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  732.510683]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  732.510686]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  732.510689]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  732.510692]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  732.510695]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  732.510699]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  732.510703]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  732.510705]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510709]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  732.510712]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  732.510715]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  732.510718]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  732.510722]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  732.510728] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  732.510731] caller is native_sched_clock+0x3c/0x68
[  732.510734] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  732.510735] Call Trace:
[  732.510739]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  732.510742]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  732.510745]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  732.510748]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  732.510751]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  732.510754]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  732.510757]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  732.510760]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  732.510764]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  732.510767]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  732.510770]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  732.510780]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  732.510783]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  732.510786]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  732.510789]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510792]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  732.510796]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  732.510798]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  732.510808]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510818]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.510828]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  732.510832]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  732.510835]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  732.510843]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  732.510846]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  732.510849]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  732.510852]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  732.510856]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  732.510859]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  732.510862]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.510866]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  732.510869]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  732.510872]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  732.510875]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  732.510878]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  732.511008] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  732.511011] caller is native_sched_clock+0x3c/0x68
[  732.511014] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  732.511016] Call Trace:
[  732.511020]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  732.511023]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  732.511026]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  732.511029]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  732.511032]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  732.511035]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  732.511038]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  732.511041]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  732.511044]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  732.511047]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  732.511051]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  732.511061]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  732.511065]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  732.511068]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  732.511071]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.511074]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  732.511077]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  732.511080]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  732.511090]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.511100]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.511110]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  732.511113]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  732.511116]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  732.511119]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  732.511122]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  732.511126]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  732.511129]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  732.511133]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  732.511136]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  732.511139]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.511143]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  732.511146]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  732.511149]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  732.511152]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  732.511155]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  732.511164] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  732.511167] caller is native_sched_clock+0x3c/0x68
[  732.511169] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  732.511171] Call Trace:
[  732.511175]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  732.511178]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  732.511181]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  732.511184]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  732.511186]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  732.511190]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  732.511193]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  732.511196]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  732.511199]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  732.511202]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  732.511206]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  732.511215]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  732.511218]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  732.511221]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  732.511225]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.511228]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  732.511231]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  732.511234]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  732.511244]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.511254]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.511264]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  732.511267]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  732.511271]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  732.511274]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  732.511277]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  732.511280]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  732.511284]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  732.511287]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  732.511291]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  732.511294]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.511298]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  732.511301]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  732.511304]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  732.511307]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  732.511310]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  732.511317] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  732.511320] caller is native_sched_clock+0x3c/0x68
[  732.511322] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  732.511324] Call Trace:
[  732.511328]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  732.511331]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  732.511334]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  732.511337]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  732.511339]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  732.511342]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  732.511346]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  732.511349]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  732.511352]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  732.511355]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  732.511359]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  732.511369]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  732.511372]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  732.511375]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  732.511378]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.511381]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  732.511384]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  732.511387]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  732.511397]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.511407]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.511417]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  732.511420]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  732.511424]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  732.511427]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  732.511430]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  732.511433]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  732.511437]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  732.511440]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  732.511444]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  732.511447]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.511451]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  732.511454]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  732.511457]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  732.511459]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  732.511463]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  732.511469] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
[  732.511472] caller is native_sched_clock+0x3c/0x68
[  732.511475] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
[  732.511476] Call Trace:
[  732.511480]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  732.511483]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  732.511486]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  732.511489]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  732.511492]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  732.511495]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  732.511498]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  732.511501]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  732.511504]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  732.511508]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  732.511511]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  732.511521]  [<ffffffffa01862b8>] ? ext4_get_block+0xa7/0xe8 [ext4]
[  732.511524]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  732.511527]  [<ffffffff81114e8f>] do_mpage_readpage+0x355/0x47e
[  732.511530]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.511533]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  732.511536]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  732.511539]  [<ffffffff811150ec>] mpage_readpages+0xd7/0x11b
[  732.511549]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.511559]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  732.511569]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  732.511573]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  732.511576]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  732.511579]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  732.511582]  [<ffffffff81044dd1>] ? current_fs_time+0x22/0x29
[  732.511586]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  732.511589]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  732.511592]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  732.511596]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  732.511599]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  732.511603]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  732.511606]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  732.511609]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  732.511612]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  732.511615]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  739.793567] debug_smp_processor_id: 161 callbacks suppressed
[  739.793571] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  739.793578] caller is native_sched_clock+0x3c/0x68
[  739.793582] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  739.793585] Call Trace:
[  739.793592]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  739.793596]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  739.793600]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  739.793604]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  739.793607]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  739.793611]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  739.793615]  [<ffffffff810e4e4f>] ? ____cache_alloc+0x1c/0x264
[  739.793620]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  739.793624]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  739.793627]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  739.793631]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  739.793635]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  739.793640]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  739.793644]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  739.793668]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  739.793672]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  739.793675]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  739.793685]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  739.793689]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  739.793693]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  739.793704]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  739.793708]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  739.793712]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  739.793716]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  739.793720]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  739.793723]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  739.793731]  [<ffffffffa0155320>] journal_submit_data_buffers+0x104/0x171 [jbd2]
[  739.793739]  [<ffffffffa0155a00>] jbd2_journal_commit_transaction+0x4a8/0x14c4 [jbd2]
[  739.793744]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  739.793748]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  739.793752]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  739.793761]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  739.793765]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  739.793773]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  739.793776]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  739.793780]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  739.793784]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  739.793787]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  739.793807] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  739.793810] caller is native_sched_clock+0x3c/0x68
[  739.793813] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  739.793815] Call Trace:
[  739.793820]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  739.793824]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  739.793828]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  739.793831]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  739.793834]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  739.793837]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  739.793842]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  739.793846]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  739.793849]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  739.793853]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  739.793857]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  739.793862]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  739.793866]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  739.793876]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  739.793880]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  739.793884]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  739.793894]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  739.793898]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  739.793902]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  739.793912]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  739.793916]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  739.793919]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  739.793923]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  739.793927]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  739.793931]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  739.793937]  [<ffffffffa0155320>] journal_submit_data_buffers+0x104/0x171 [jbd2]
[  739.793945]  [<ffffffffa0155a00>] jbd2_journal_commit_transaction+0x4a8/0x14c4 [jbd2]
[  739.793950]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  739.793954]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  739.793958]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  739.793965]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  739.793969]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  739.793977]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  739.793980]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  739.793984]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  739.793988]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  739.793991]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  739.794031] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  739.794034] caller is native_sched_clock+0x3c/0x68
[  739.794037] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  739.794039] Call Trace:
[  739.794043]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  739.794047]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  739.794050]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  739.794054]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  739.794057]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  739.794061]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  739.794065]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  739.794068]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  739.794071]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  739.794075]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  739.794082]  [<ffffffffa0153277>] ? jbd_unlock_bh_state+0x13/0x2e [jbd2]
[  739.794086]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  739.794090]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  739.794097]  [<ffffffffa0155f44>] jbd2_journal_commit_transaction+0x9ec/0x14c4 [jbd2]
[  739.794101]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  739.794105]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  739.794113]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  739.794117]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  739.794125]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  739.794128]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  739.794132]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  739.794135]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  739.794139]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  739.795054] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  739.795059] caller is native_sched_clock+0x3c/0x68
[  739.795062] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  739.795065] Call Trace:
[  739.795069]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  739.795073]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  739.795076]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  739.795080]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  739.795083]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  739.795087]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  739.795091]  [<ffffffff810b8293>] ? __alloc_pages_nodemask+0xf3/0x60c
[  739.795095]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  739.795098]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  739.795102]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  739.795106]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  739.795109]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  739.795113]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  739.795116]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  739.795127]  [<ffffffffa0155484>] journal_submit_commit_record+0xf7/0x16b [jbd2]
[  739.795135]  [<ffffffffa015638b>] jbd2_journal_commit_transaction+0xe33/0x14c4 [jbd2]
[  739.795139]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  739.795143]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  739.795151]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  739.795156]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  739.795163]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  739.795166]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  739.795170]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  739.795174]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  739.795177]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  740.250278] BUG: using smp_processor_id() in preemptible [00000000] code: mocp/5600
[  740.250285] caller is native_sched_clock+0x3c/0x68
[  740.250288] Pid: 5600, comm: mocp Tainted: P            2.6.34-20100524-0407 #1
[  740.250290] Call Trace:
[  740.250297]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  740.250300]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  740.250304]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  740.250307]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  740.250310]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  740.250313]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  740.250317]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  740.250320]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  740.250323]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  740.250327]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  740.250330]  [<ffffffff81114f03>] ? do_mpage_readpage+0x3c9/0x47e
[  740.250334]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  740.250338]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  740.250341]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  740.250344]  [<ffffffff8111511c>] mpage_readpages+0x107/0x11b
[  740.250365]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  740.250375]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  740.250385]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  740.250389]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  740.250393]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  740.250396]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  740.250399]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  740.250402]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  740.250406]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  740.250409]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  740.250414]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  740.250417]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  740.250422]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  740.250425]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  740.250428]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  740.250430]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  740.250434]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  744.133760] BUG: using smp_processor_id() in preemptible [00000000] code: postgres/2357
[  744.133767] caller is native_sched_clock+0x3c/0x68
[  744.133770] Pid: 2357, comm: postgres Tainted: P            2.6.34-20100524-0407 #1
[  744.133773] Call Trace:
[  744.133781]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  744.133784]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  744.133788]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  744.133791]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  744.133794]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  744.133798]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  744.133801]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  744.133805]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  744.133808]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  744.133811]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  744.133815]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  744.133819]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  744.133823]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  744.133845]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  744.133848]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  744.133852]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  744.133862]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  744.133866]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  744.133869]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  744.133879]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  744.133889]  [<ffffffffa01832e5>] mpage_da_submit_io+0xea/0x165 [ext4]
[  744.133900]  [<ffffffffa0185dbe>] ext4_da_writepages+0x363/0x574 [ext4]
[  744.133904]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  744.133909]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  744.133913]  [<ffffffff810b280d>] __filemap_fdatawrite_range+0x4b/0x4d
[  744.133916]  [<ffffffff810b2cff>] filemap_flush+0x17/0x19
[  744.133926]  [<ffffffffa01834e2>] ext4_alloc_da_blocks+0x6b/0x70 [ext4]
[  744.133936]  [<ffffffffa018bddb>] ext4_rename+0x633/0x64f [ext4]
[  744.133941]  [<ffffffff810f5c54>] vfs_rename+0x21c/0x3c0
[  744.133944]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  744.133948]  [<ffffffff810f7527>] sys_renameat+0x1a1/0x25c
[  744.133952]  [<ffffffff810e3f87>] ? __cache_free+0x1c/0x1a4
[  744.133955]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  744.133959]  [<ffffffff810ce163>] ? remove_vma+0x69/0x71
[  744.133962]  [<ffffffff810cf2b4>] ? do_munmap+0x30b/0x32d
[  744.133966]  [<ffffffff810f75f8>] sys_rename+0x16/0x18
[  744.133970]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  744.145536] BUG: using smp_processor_id() in preemptible [00000000] code: postgres/2357
[  744.145544] caller is native_sched_clock+0x3c/0x68
[  744.145548] Pid: 2357, comm: postgres Tainted: P            2.6.34-20100524-0407 #1
[  744.145551] Call Trace:
[  744.145559]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  744.145562]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  744.145566]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  744.145569]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  744.145573]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  744.145576]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  744.145580]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  744.145583]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  744.145586]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  744.145589]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  744.145593]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  744.145597]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  744.145601]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  744.145626]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  744.145630]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  744.145633]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  744.145643]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  744.145647]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  744.145651]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  744.145661]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  744.145671]  [<ffffffffa01832e5>] mpage_da_submit_io+0xea/0x165 [ext4]
[  744.145681]  [<ffffffffa0185dbe>] ext4_da_writepages+0x363/0x574 [ext4]
[  744.145685]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  744.145690]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  744.145694]  [<ffffffff810b280d>] __filemap_fdatawrite_range+0x4b/0x4d
[  744.145697]  [<ffffffff810b2cff>] filemap_flush+0x17/0x19
[  744.145707]  [<ffffffffa01834e2>] ext4_alloc_da_blocks+0x6b/0x70 [ext4]
[  744.145717]  [<ffffffffa018bddb>] ext4_rename+0x633/0x64f [ext4]
[  744.145722]  [<ffffffff810f5c54>] vfs_rename+0x21c/0x3c0
[  744.145724]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  744.145728]  [<ffffffff810f7527>] sys_renameat+0x1a1/0x25c
[  744.145733]  [<ffffffff810e3f87>] ? __cache_free+0x1c/0x1a4
[  744.145735]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  744.145739]  [<ffffffff810ce163>] ? remove_vma+0x69/0x71
[  744.145742]  [<ffffffff810cf2b4>] ? do_munmap+0x30b/0x32d
[  744.145746]  [<ffffffff810f75f8>] sys_rename+0x16/0x18
[  744.145750]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  744.345656] BUG: using smp_processor_id() in preemptible [00000000] code: mocp/5600
[  744.345663] caller is native_sched_clock+0x3c/0x68
[  744.345666] Pid: 5600, comm: mocp Tainted: P            2.6.34-20100524-0407 #1
[  744.345668] Call Trace:
[  744.345675]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  744.345678]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  744.345681]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  744.345685]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  744.345688]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  744.345691]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  744.345695]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  744.345698]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  744.345701]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  744.345705]  [<ffffffff811148f5>] ? mpage_alloc+0x25/0x7d
[  744.345708]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  744.345711]  [<ffffffff81114f03>] ? do_mpage_readpage+0x3c9/0x47e
[  744.345714]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  744.345718]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  744.345721]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  744.345724]  [<ffffffff8111511c>] mpage_readpages+0x107/0x11b
[  744.345747]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  744.345757]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  744.345767]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  744.345771]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  744.345774]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  744.345777]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  744.345780]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  744.345783]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  744.345787]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  744.345791]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  744.345795]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  744.345798]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  744.345803]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  744.345806]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  744.345808]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  744.345812]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  744.345815]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  745.075681] BUG: using smp_processor_id() in preemptible [00000000] code: knotify4/4851
[  745.075688] caller is native_sched_clock+0x3c/0x68
[  745.075692] Pid: 4851, comm: knotify4 Tainted: P            2.6.34-20100524-0407 #1
[  745.075694] Call Trace:
[  745.075703]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  745.075708]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  745.075711]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  745.075714]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  745.075718]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  745.075721]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  745.075726]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  745.075729]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  745.075732]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  745.075735]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  745.075739]  [<ffffffff81114f03>] ? do_mpage_readpage+0x3c9/0x47e
[  745.075743]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  745.075747]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  745.075751]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  745.075754]  [<ffffffff8111511c>] mpage_readpages+0x107/0x11b
[  745.075777]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  745.075787]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  745.075800]  [<ffffffffa019dcc0>] ? __ext4_ext_check+0xfa/0x1c4 [ext4]
[  745.075803]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  745.075813]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  745.075817]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  745.075821]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  745.075824]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  745.075828]  [<ffffffff810ba714>] page_cache_sync_readahead+0x38/0x3c
[  745.075832]  [<ffffffff810b3796>] generic_file_aio_read+0x217/0x541
[  745.075835]  [<ffffffff810b8293>] ? __alloc_pages_nodemask+0xf3/0x60c
[  745.075840]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  745.075843]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  745.075848]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  745.075851]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  745.075855]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  745.075857]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  745.075862]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  745.076529] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  745.076537] caller is native_sched_clock+0x3c/0x68
[  745.076540] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  745.076543] Call Trace:
[  745.076549]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  745.076553]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  745.076556]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  745.076559]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  745.076562]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  745.076565]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  745.076569]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  745.076572]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  745.076575]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  745.076578]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  745.076596]  [<ffffffffa0153277>] ? jbd_unlock_bh_state+0x13/0x2e [jbd2]
[  745.076599]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  745.076604]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  745.076610]  [<ffffffffa0155f44>] jbd2_journal_commit_transaction+0x9ec/0x14c4 [jbd2]
[  745.076615]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  745.076622]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  745.076626]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  745.076633]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  745.076636]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  745.076640]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  745.076643]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  745.076645]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  745.098156] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  745.098163] caller is native_sched_clock+0x3c/0x68
[  745.098167] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  745.098170] Call Trace:
[  745.098177]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  745.098180]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  745.098184]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  745.098187]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  745.098190]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  745.098193]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  745.098198]  [<ffffffff810b8293>] ? __alloc_pages_nodemask+0xf3/0x60c
[  745.098202]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  745.098205]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  745.098208]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  745.098212]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  745.098215]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  745.098218]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  745.098222]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  745.098231]  [<ffffffffa0155484>] journal_submit_commit_record+0xf7/0x16b [jbd2]
[  745.098238]  [<ffffffffa015638b>] jbd2_journal_commit_transaction+0xe33/0x14c4 [jbd2]
[  745.098243]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  745.098251]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  745.098254]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  745.098262]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  745.098264]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  745.098268]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  745.098271]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  745.098274]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  747.546200] BUG: using smp_processor_id() in preemptible [00000000] code: mocp/5600
[  747.546207] caller is native_sched_clock+0x3c/0x68
[  747.546210] Pid: 5600, comm: mocp Tainted: P            2.6.34-20100524-0407 #1
[  747.546212] Call Trace:
[  747.546219]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  747.546223]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  747.546226]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  747.546229]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  747.546232]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  747.546235]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  747.546239]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  747.546242]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  747.546245]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  747.546249]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  747.546252]  [<ffffffff81114f03>] ? do_mpage_readpage+0x3c9/0x47e
[  747.546255]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  747.546259]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  747.546262]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  747.546265]  [<ffffffff8111511c>] mpage_readpages+0x107/0x11b
[  747.546287]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  747.546290]  [<ffffffff81039ebb>] ? dequeue_entity+0x1b/0x115
[  747.546300]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  747.546310]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  747.546314]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  747.546318]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  747.546321]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  747.546324]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  747.546327]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  747.546331]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  747.546334]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  747.546339]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  747.546341]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  747.546346]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  747.546349]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  747.546352]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  747.546355]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  747.546359]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  747.808091] BUG: using smp_processor_id() in preemptible [00000000] code: flush-8:0/2328
[  747.808099] caller is native_sched_clock+0x3c/0x68
[  747.808102] Pid: 2328, comm: flush-8:0 Tainted: P            2.6.34-20100524-0407 #1
[  747.808104] Call Trace:
[  747.808111]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  747.808115]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  747.808118]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  747.808122]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  747.808125]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  747.808129]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  747.808151]  [<ffffffffa0181afc>] ? ext4_mark_inode_dirty+0x179/0x1ac [ext4]
[  747.808156]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  747.808159]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  747.808162]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  747.808166]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  747.808169]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  747.808173]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  747.808176]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  747.808181]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  747.808184]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  747.808195]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  747.808198]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  747.808202]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  747.808212]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  747.808216]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  747.808220]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  747.808230]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  747.808240]  [<ffffffffa01832e5>] mpage_da_submit_io+0xea/0x165 [ext4]
[  747.808251]  [<ffffffffa0185dbe>] ext4_da_writepages+0x363/0x574 [ext4]
[  747.808255]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  747.808259]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  747.808263]  [<ffffffff811077ac>] writeback_single_inode+0xde/0x300
[  747.808267]  [<ffffffff811080fb>] writeback_inodes_wb+0x429/0x530
[  747.808271]  [<ffffffff8110834b>] wb_writeback+0x149/0x1d0
[  747.808275]  [<ffffffff811085a3>] wb_do_writeback+0x1b9/0x1cf
[  747.808279]  [<ffffffff8104d043>] ? process_timeout+0x0/0xb
[  747.808283]  [<ffffffff811085f7>] bdi_writeback_task+0x3e/0x117
[  747.808287]  [<ffffffff8105a516>] ? bit_waitqueue+0x12/0xa4
[  747.808291]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  747.808294]  [<ffffffff810c6abf>] bdi_start_fn+0x71/0xd5
[  747.808298]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  747.808301]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  747.808304]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  747.808308]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  747.808311]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  747.808407] BUG: using smp_processor_id() in preemptible [00000000] code: flush-8:0/2328
[  747.808410] caller is native_sched_clock+0x3c/0x68
[  747.808413] Pid: 2328, comm: flush-8:0 Tainted: P            2.6.34-20100524-0407 #1
[  747.808414] Call Trace:
[  747.808419]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  747.808423]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  747.808426]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  747.808429]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  747.808432]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  747.808436]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  747.808440]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  747.808444]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  747.808448]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  747.808451]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  747.808455]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  747.808459]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  747.808463]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  747.808473]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  747.808476]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  747.808480]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  747.808491]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  747.808495]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  747.808498]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  747.808509]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  747.808519]  [<ffffffffa01832e5>] mpage_da_submit_io+0xea/0x165 [ext4]
[  747.808530]  [<ffffffffa0185dbe>] ext4_da_writepages+0x363/0x574 [ext4]
[  747.808534]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  747.808538]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  747.808541]  [<ffffffff811077ac>] writeback_single_inode+0xde/0x300
[  747.808545]  [<ffffffff811080fb>] writeback_inodes_wb+0x429/0x530
[  747.808549]  [<ffffffff8110834b>] wb_writeback+0x149/0x1d0
[  747.808553]  [<ffffffff811085a3>] wb_do_writeback+0x1b9/0x1cf
[  747.808557]  [<ffffffff8104d043>] ? process_timeout+0x0/0xb
[  747.808560]  [<ffffffff811085f7>] bdi_writeback_task+0x3e/0x117
[  747.808564]  [<ffffffff8105a516>] ? bit_waitqueue+0x12/0xa4
[  747.808567]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  747.808570]  [<ffffffff810c6abf>] bdi_start_fn+0x71/0xd5
[  747.808574]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  747.808576]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  747.808580]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  747.808583]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  747.808587]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  747.808670] BUG: using smp_processor_id() in preemptible [00000000] code: flush-8:0/2328
[  747.808674] caller is native_sched_clock+0x3c/0x68
[  747.808676] Pid: 2328, comm: flush-8:0 Tainted: P            2.6.34-20100524-0407 #1
[  747.808678] Call Trace:
[  747.808682]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  747.808686]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  747.808689]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  747.808693]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  747.808695]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  747.808699]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  747.808703]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  747.808707]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  747.808710]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  747.808713]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  747.808717]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  747.808721]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  747.808724]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  747.808735]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  747.808738]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  747.808742]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  747.808752]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  747.808756]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  747.808760]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  747.808770]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  747.808780]  [<ffffffffa01832e5>] mpage_da_submit_io+0xea/0x165 [ext4]
[  747.808791]  [<ffffffffa0185dbe>] ext4_da_writepages+0x363/0x574 [ext4]
[  747.808795]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  747.808799]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  747.808803]  [<ffffffff811077ac>] writeback_single_inode+0xde/0x300
[  747.808806]  [<ffffffff811080fb>] writeback_inodes_wb+0x429/0x530
[  747.808810]  [<ffffffff8110834b>] wb_writeback+0x149/0x1d0
[  747.808815]  [<ffffffff811085a3>] wb_do_writeback+0x1b9/0x1cf
[  747.808818]  [<ffffffff8104d043>] ? process_timeout+0x0/0xb
[  747.808822]  [<ffffffff811085f7>] bdi_writeback_task+0x3e/0x117
[  747.808825]  [<ffffffff8105a516>] ? bit_waitqueue+0x12/0xa4
[  747.808829]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  747.808832]  [<ffffffff810c6abf>] bdi_start_fn+0x71/0xd5
[  747.808836]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  747.808838]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  747.808842]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  747.808846]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  747.808848]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  750.748232] BUG: using smp_processor_id() in preemptible [00000000] code: mocp/5600
[  750.748239] caller is native_sched_clock+0x3c/0x68
[  750.748243] Pid: 5600, comm: mocp Tainted: P            2.6.34-20100524-0407 #1
[  750.748245] Call Trace:
[  750.748252]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  750.748255]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  750.748258]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  750.748262]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  750.748265]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  750.748268]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  750.748272]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  750.748275]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  750.748278]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  750.748282]  [<ffffffff811148f5>] ? mpage_alloc+0x25/0x7d
[  750.748285]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  750.748288]  [<ffffffff81114f03>] ? do_mpage_readpage+0x3c9/0x47e
[  750.748291]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  750.748295]  [<ffffffff810bad46>] ? __lru_cache_add+0x73/0x91
[  750.748297]  [<ffffffff8111496f>] mpage_bio_submit+0x22/0x26
[  750.748300]  [<ffffffff8111511c>] mpage_readpages+0x107/0x11b
[  750.748323]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  750.748334]  [<ffffffffa0186211>] ? ext4_get_block+0x0/0xe8 [ext4]
[  750.748344]  [<ffffffffa0182ee8>] ext4_readpages+0x18/0x1a [ext4]
[  750.748349]  [<ffffffff810ba19b>] __do_page_cache_readahead+0x128/0x1be
[  750.748353]  [<ffffffff810ba24d>] ra_submit+0x1c/0x20
[  750.748356]  [<ffffffff810ba62d>] ondemand_readahead+0x1b1/0x1c4
[  750.748359]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  750.748363]  [<ffffffff810ba6b6>] page_cache_async_readahead+0x76/0x9c
[  750.748367]  [<ffffffff810b2178>] ? find_get_page+0x7b/0x87
[  750.748371]  [<ffffffff810b37d3>] generic_file_aio_read+0x254/0x541
[  750.748380]  [<ffffffff810ec6cc>] do_sync_read+0xc6/0x103
[  750.748383]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  750.748388]  [<ffffffff81155d8e>] ? security_file_permission+0x11/0x13
[  750.748391]  [<ffffffff810ecce2>] vfs_read+0xa6/0x103
[  750.748394]  [<ffffffff810ed80e>] ? fget_light+0xa0/0xac
[  750.748397]  [<ffffffff810ecdf5>] sys_read+0x45/0x69
[  750.748401]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  750.749925] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  750.749929] caller is native_sched_clock+0x3c/0x68
[  750.749932] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  750.749934] Call Trace:
[  750.749938]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  750.749941]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  750.749945]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  750.749947]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  750.749950]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  750.749954]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  750.749958]  [<ffffffff810e4e4f>] ? ____cache_alloc+0x1c/0x264
[  750.749961]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  750.749965]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  750.749967]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  750.749971]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  750.749975]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  750.749979]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  750.749982]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  750.749993]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  750.749996]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  750.749999]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  750.750010]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  750.750013]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  750.750017]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  750.750027]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  750.750031]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  750.750034]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  750.750038]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  750.750041]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  750.750045]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  750.750052]  [<ffffffffa0155320>] journal_submit_data_buffers+0x104/0x171 [jbd2]
[  750.750059]  [<ffffffffa0155a00>] jbd2_journal_commit_transaction+0x4a8/0x14c4 [jbd2]
[  750.750063]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  750.750068]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  750.750072]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  750.750080]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  750.750084]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  750.750091]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  750.750094]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  750.750097]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  750.750101]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  750.750104]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  750.750124] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  750.750127] caller is native_sched_clock+0x3c/0x68
[  750.750130] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  750.750132] Call Trace:
[  750.750136]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  750.750139]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  750.750142]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  750.750145]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  750.750148]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  750.750151]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  750.750156]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  750.750159]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  750.750162]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  750.750166]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  750.750170]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  750.750173]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  750.750176]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  750.750187]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  750.750190]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  750.750194]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  750.750204]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  750.750208]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  750.750211]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  750.750221]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  750.750224]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  750.750227]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  750.750231]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  750.750234]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  750.750238]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  750.750244]  [<ffffffffa0155320>] journal_submit_data_buffers+0x104/0x171 [jbd2]
[  750.750251]  [<ffffffffa0155a00>] jbd2_journal_commit_transaction+0x4a8/0x14c4 [jbd2]
[  750.750256]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  750.750259]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  750.750262]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  750.750270]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  750.750273]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  750.750280]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  750.750284]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  750.750287]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  750.750290]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  750.750294]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  750.750305] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  750.750308] caller is native_sched_clock+0x3c/0x68
[  750.750311] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  750.750313] Call Trace:
[  750.750316]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  750.750320]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  750.750323]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  750.750326]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  750.750329]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  750.750332]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  750.750337]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  750.750340]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  750.750343]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  750.750346]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  750.750350]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  750.750354]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  750.750357]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  750.750367]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  750.750370]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  750.750374]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  750.750384]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  750.750388]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  750.750392]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  750.750401]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  750.750405]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  750.750409]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  750.750411]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  750.750416]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  750.750420]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  750.750426]  [<ffffffffa0155320>] journal_submit_data_buffers+0x104/0x171 [jbd2]
[  750.750434]  [<ffffffffa0155a00>] jbd2_journal_commit_transaction+0x4a8/0x14c4 [jbd2]
[  750.750438]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  750.750441]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  750.750444]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  750.750452]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  750.750456]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  750.750463]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  750.750466]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  750.750470]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  750.750473]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  750.750476]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  750.750486] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  750.750489] caller is native_sched_clock+0x3c/0x68
[  750.750491] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  750.750494] Call Trace:
[  750.750497]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  750.750501]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  750.750504]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  750.750507]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  750.750510]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  750.750513]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  750.750517]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  750.750520]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  750.750524]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  750.750527]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  750.750531]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  750.750535]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  750.750538]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  750.750549]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  750.750552]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  750.750556]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  750.750566]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  750.750569]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  750.750573]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  750.750583]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  750.750586]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  750.750589]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  750.750593]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  750.750596]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  750.750600]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  750.750606]  [<ffffffffa0155320>] journal_submit_data_buffers+0x104/0x171 [jbd2]
[  750.750614]  [<ffffffffa0155a00>] jbd2_journal_commit_transaction+0x4a8/0x14c4 [jbd2]
[  750.750618]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  750.750621]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  750.750624]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  750.750632]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  750.750635]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  750.750643]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  750.750646]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  750.750649]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  750.750652]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  750.750655]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  750.750698] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  750.750701] caller is native_sched_clock+0x3c/0x68
[  750.750704] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  750.750706] Call Trace:
[  750.750710]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  750.750714]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  750.750717]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  750.750719]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  750.750722]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  750.750725]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  750.750729]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  750.750732]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  750.750736]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  750.750739]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  750.750746]  [<ffffffffa0153277>] ? jbd_unlock_bh_state+0x13/0x2e [jbd2]
[  750.750749]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  750.750752]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  750.750759]  [<ffffffffa0155f44>] jbd2_journal_commit_transaction+0x9ec/0x14c4 [jbd2]
[  750.750763]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  750.750767]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  750.750774]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  750.750778]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  750.750785]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  750.750788]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  750.750791]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  750.750795]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  750.750797]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  750.760626] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  750.760630] caller is native_sched_clock+0x3c/0x68
[  750.760632] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  750.760634] Call Trace:
[  750.760637]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  750.760641]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  750.760644]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  750.760646]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  750.760649]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  750.760652]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  750.760655]  [<ffffffff810b8293>] ? __alloc_pages_nodemask+0xf3/0x60c
[  750.760659]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  750.760661]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  750.760665]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  750.760668]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  750.760671]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  750.760674]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  750.760677]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  750.760684]  [<ffffffffa0155484>] journal_submit_commit_record+0xf7/0x16b [jbd2]
[  750.760691]  [<ffffffffa015638b>] jbd2_journal_commit_transaction+0xe33/0x14c4 [jbd2]
[  750.760695]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  750.760698]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  750.760706]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  750.760709]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  750.760716]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  750.760719]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  750.760722]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  750.760725]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  750.760728]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  751.619027] BUG: using smp_processor_id() in preemptible [00000000] code: choosesig.pl/5975
[  751.619034] caller is native_sched_clock+0x3c/0x68
[  751.619038] Pid: 5975, comm: choosesig.pl Tainted: P            2.6.34-20100524-0407 #1
[  751.619040] Call Trace:
[  751.619047]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  751.619051]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  751.619054]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  751.619058]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  751.619061]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  751.619064]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  751.619088]  [<ffffffffa0181afc>] ? ext4_mark_inode_dirty+0x179/0x1ac [ext4]
[  751.619092]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  751.619095]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  751.619098]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  751.619101]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  751.619104]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  751.619108]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  751.619112]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  751.619116]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  751.619120]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  751.619130]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  751.619134]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  751.619137]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  751.619147]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  751.619151]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  751.619155]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  751.619165]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  751.619175]  [<ffffffffa01832e5>] mpage_da_submit_io+0xea/0x165 [ext4]
[  751.619186]  [<ffffffffa0185dbe>] ext4_da_writepages+0x363/0x574 [ext4]
[  751.619191]  [<ffffffff810e3f87>] ? __cache_free+0x1c/0x1a4
[  751.619195]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  751.619200]  [<ffffffff810b280d>] __filemap_fdatawrite_range+0x4b/0x4d
[  751.619204]  [<ffffffff810b2cff>] filemap_flush+0x17/0x19
[  751.619213]  [<ffffffffa01834e2>] ext4_alloc_da_blocks+0x6b/0x70 [ext4]
[  751.619222]  [<ffffffffa017e771>] ext4_release_file+0x25/0xa0 [ext4]
[  751.619226]  [<ffffffff810ed989>] __fput+0xf9/0x1a3
[  751.619229]  [<ffffffff810eda48>] fput+0x15/0x17
[  751.619232]  [<ffffffff810eaed5>] filp_close+0x63/0x6d
[  751.619236]  [<ffffffff8104247a>] put_files_struct+0x6f/0xc7
[  751.619239]  [<ffffffff81042518>] exit_files+0x46/0x4e
[  751.619241]  [<ffffffff81043d73>] do_exit+0x281/0x74e
[  751.619245]  [<ffffffff81026c05>] ? do_page_fault+0x212/0x241
[  751.619248]  [<ffffffff810442b3>] do_group_exit+0x73/0x9c
[  751.619252]  [<ffffffff810442ee>] sys_exit_group+0x12/0x16
[  751.619256]  [<ffffffff81002b02>] system_call_fastpath+0x16/0x1b
[  752.810185] BUG: using smp_processor_id() in preemptible [00000000] code: flush-8:0/2328
[  752.810192] caller is native_sched_clock+0x3c/0x68
[  752.810196] Pid: 2328, comm: flush-8:0 Tainted: P            2.6.34-20100524-0407 #1
[  752.810198] Call Trace:
[  752.810205]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  752.810209]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  752.810212]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  752.810216]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  752.810219]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  752.810223]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  752.810226]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  752.810230]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  752.810233]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  752.810235]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  752.810239]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  752.810242]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  752.810246]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  752.810250]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  752.810254]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  752.810277]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  752.810281]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  752.810284]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  752.810294]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  752.810297]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  752.810301]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  752.810311]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  752.810321]  [<ffffffffa01832e5>] mpage_da_submit_io+0xea/0x165 [ext4]
[  752.810332]  [<ffffffffa01860b5>] __mpage_da_writepage+0x44/0x14b [ext4]
[  752.810336]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  752.810344]  [<ffffffffa01547de>] ? start_this_handle+0x566/0x58e [jbd2]
[  752.810353]  [<ffffffffa0186071>] ? __mpage_da_writepage+0x0/0x14b [ext4]
[  752.810364]  [<ffffffffa0185d95>] ext4_da_writepages+0x33a/0x574 [ext4]
[  752.810368]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  752.810372]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  752.810376]  [<ffffffff811077ac>] writeback_single_inode+0xde/0x300
[  752.810379]  [<ffffffff811080fb>] writeback_inodes_wb+0x429/0x530
[  752.810383]  [<ffffffff8110834b>] wb_writeback+0x149/0x1d0
[  752.810387]  [<ffffffff811085a3>] wb_do_writeback+0x1b9/0x1cf
[  752.810391]  [<ffffffff8104d043>] ? process_timeout+0x0/0xb
[  752.810395]  [<ffffffff811085f7>] bdi_writeback_task+0x3e/0x117
[  752.810398]  [<ffffffff8105a516>] ? bit_waitqueue+0x12/0xa4
[  752.810402]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  752.810406]  [<ffffffff810c6abf>] bdi_start_fn+0x71/0xd5
[  752.810409]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  752.810412]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  752.810416]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  752.810419]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  752.810422]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  752.810442] BUG: using smp_processor_id() in preemptible [00000000] code: flush-8:0/2328
[  752.810445] caller is native_sched_clock+0x3c/0x68
[  752.810448] Pid: 2328, comm: flush-8:0 Tainted: P            2.6.34-20100524-0407 #1
[  752.810450] Call Trace:
[  752.810454]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  752.810457]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  752.810460]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  752.810463]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  752.810466]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  752.810469]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  752.810473]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  752.810477]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  752.810480]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  752.810484]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  752.810487]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  752.810491]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  752.810494]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  752.810505]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  752.810508]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  752.810512]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  752.810522]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  752.810525]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  752.810529]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  752.810539]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  752.810549]  [<ffffffffa01832e5>] mpage_da_submit_io+0xea/0x165 [ext4]
[  752.810559]  [<ffffffffa01860b5>] __mpage_da_writepage+0x44/0x14b [ext4]
[  752.810563]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  752.810569]  [<ffffffffa01547de>] ? start_this_handle+0x566/0x58e [jbd2]
[  752.810579]  [<ffffffffa0186071>] ? __mpage_da_writepage+0x0/0x14b [ext4]
[  752.810590]  [<ffffffffa0185d95>] ext4_da_writepages+0x33a/0x574 [ext4]
[  752.810594]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  752.810597]  [<ffffffff810b9f64>] do_writepages+0x1c/0x25
[  752.810601]  [<ffffffff811077ac>] writeback_single_inode+0xde/0x300
[  752.810605]  [<ffffffff811080fb>] writeback_inodes_wb+0x429/0x530
[  752.810608]  [<ffffffff8110834b>] wb_writeback+0x149/0x1d0
[  752.810613]  [<ffffffff811085a3>] wb_do_writeback+0x1b9/0x1cf
[  752.810616]  [<ffffffff8104d043>] ? process_timeout+0x0/0xb
[  752.810620]  [<ffffffff811085f7>] bdi_writeback_task+0x3e/0x117
[  752.810623]  [<ffffffff8105a516>] ? bit_waitqueue+0x12/0xa4
[  752.810626]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  752.810629]  [<ffffffff810c6abf>] bdi_start_fn+0x71/0xd5
[  752.810632]  [<ffffffff810c6a4e>] ? bdi_start_fn+0x0/0xd5
[  752.810635]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  752.810638]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  752.810642]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  752.810644]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  755.826679] debug_smp_processor_id: 6 callbacks suppressed
[  755.826682] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  755.826688] caller is native_sched_clock+0x3c/0x68
[  755.826691] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  755.826694] Call Trace:
[  755.826700]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  755.826704]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  755.826707]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  755.826710]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  755.826713]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  755.826717]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  755.826721]  [<ffffffff810e4e4f>] ? ____cache_alloc+0x1c/0x264
[  755.826724]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  755.826728]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  755.826731]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  755.826734]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  755.826737]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  755.826741]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  755.826745]  [<ffffffff8110f7ed>] __block_write_full_page+0x1cd/0x2a8
[  755.826763]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  755.826767]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  755.826770]  [<ffffffff8110e651>] ? end_buffer_async_write+0x0/0x136
[  755.826780]  [<ffffffffa01861bc>] ? noalloc_get_block_write+0x0/0x55 [ext4]
[  755.826783]  [<ffffffff8110f94c>] block_write_full_page_endio+0x84/0x90
[  755.826787]  [<ffffffff8110f968>] block_write_full_page+0x10/0x12
[  755.826797]  [<ffffffffa0184375>] ext4_writepage+0x38d/0x3d4 [ext4]
[  755.826801]  [<ffffffff810b8c2c>] __writepage+0x12/0x2b
[  755.826804]  [<ffffffff810b9df8>] write_cache_pages+0x1f5/0x324
[  755.826807]  [<ffffffff810b8c1a>] ? __writepage+0x0/0x2b
[  755.826811]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  755.826814]  [<ffffffff810b9f46>] generic_writepages+0x1f/0x21
[  755.826821]  [<ffffffffa0155320>] journal_submit_data_buffers+0x104/0x171 [jbd2]
[  755.826829]  [<ffffffffa0155a00>] jbd2_journal_commit_transaction+0x4a8/0x14c4 [jbd2]
[  755.826832]  [<ffffffff8103733d>] ? sub_preempt_count+0x92/0xa6
[  755.826837]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  755.826840]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  755.826848]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  755.826852]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  755.826860]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  755.826863]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  755.826866]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  755.826870]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  755.826872]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  755.826946] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  755.826949] caller is native_sched_clock+0x3c/0x68
[  755.826952] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  755.826954] Call Trace:
[  755.826957]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  755.826960]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  755.826963]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  755.826966]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  755.826969]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  755.826972]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  755.826976]  [<ffffffff8119443f>] ? cfq_merge+0x74/0xa0
[  755.826980]  [<ffffffff8117f240>] ? elv_merge+0x166/0x19e
[  755.826983]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  755.826986]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  755.826993]  [<ffffffffa0153277>] ? jbd_unlock_bh_state+0x13/0x2e [jbd2]
[  755.826996]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  755.826999]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  755.827006]  [<ffffffffa0155f44>] jbd2_journal_commit_transaction+0x9ec/0x14c4 [jbd2]
[  755.827010]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  755.827013]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  755.827021]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  755.827024]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  755.827032]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  755.827034]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  755.827038]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  755.827041]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  755.827044]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10
[  755.828245] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2-8/1372
[  755.828249] caller is native_sched_clock+0x3c/0x68
[  755.828251] Pid: 1372, comm: jbd2/sda2-8 Tainted: P            2.6.34-20100524-0407 #1
[  755.828253] Call Trace:
[  755.828256]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
[  755.828260]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
[  755.828263]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
[  755.828265]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
[  755.828268]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
[  755.828271]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
[  755.828274]  [<ffffffff810b8293>] ? __alloc_pages_nodemask+0xf3/0x60c
[  755.828278]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  755.828280]  [<ffffffff810373fe>] ? add_preempt_count+0xad/0xb2
[  755.828283]  [<ffffffff811849b8>] __make_request+0x32b/0x44e
[  755.828287]  [<ffffffff81183c9a>] generic_make_request+0x249/0x2be
[  755.828290]  [<ffffffff81035856>] ? get_parent_ip+0x11/0x41
[  755.828293]  [<ffffffff81183ddc>] submit_bio+0xcd/0xea
[  755.828297]  [<ffffffff8110cf60>] submit_bh+0xef/0x111
[  755.828304]  [<ffffffffa0155484>] journal_submit_commit_record+0xf7/0x16b [jbd2]
[  755.828310]  [<ffffffffa015638b>] jbd2_journal_commit_transaction+0xe33/0x14c4 [jbd2]
[  755.828314]  [<ffffffff8130e64b>] ? _raw_spin_unlock_irqrestore+0x32/0x3d
[  755.828318]  [<ffffffff8104cf98>] ? try_to_del_timer_sync+0x76/0x84
[  755.828325]  [<ffffffffa015b65c>] kjournald2+0x138/0x365 [jbd2]
[  755.828328]  [<ffffffff8105a5fb>] ? autoremove_wake_function+0x0/0x34
[  755.828335]  [<ffffffffa015b524>] ? kjournald2+0x0/0x365 [jbd2]
[  755.828338]  [<ffffffff8105a15f>] kthread+0x7a/0x82
[  755.828341]  [<ffffffff81003924>] kernel_thread_helper+0x4/0x10
[  755.828344]  [<ffffffff8105a0e5>] ? kthread+0x0/0x82
[  755.828347]  [<ffffffff81003920>] ? kernel_thread_helper+0x0/0x10

--------------020107070507000301080008--
