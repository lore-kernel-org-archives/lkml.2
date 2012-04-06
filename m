Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2DFQln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 12:41:43 -0400
Received: from mail.southpole.se ([193.12.106.18]:38647 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab2DFQlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 12:41:42 -0400
Message-ID: <1333730496.17877.7.camel@satguru>
Subject: Re: [PATCH 04/19 v2] openrisc/mm/fault.c: Port OOM changes to
 do_page_fault
From: Jonas Bonn <jonas@southpole.se>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux@openrisc.net,
        linux-kernel@vger.kernel.org, "Mohd. Faris" <mohdfarisq2010@gmail.com>
Date: Fri, 06 Apr 2012 18:41:36 +0200
In-Reply-To: <1333195251-5046-1-git-send-email-consul.kautuk@gmail.com>
References: <1333195251-5046-1-git-send-email-consul.kautuk@gmail.com>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-dq5ywcll13kiQnWeaJ2V"
X-Mailer: Evolution 3.2.3-0ubuntu5 
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 30498-04263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-dq5ywcll13kiQnWeaJ2V
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Kautuk,

OK, I had a look at this patch and I think it's fine.  This is a little
over my head so I'm just going to take you word for it doing the right
thing... it doesn't seem to fundamentally break anything in any case.
stress_32k runs and the OOM killer takes it down nicely.

I'll paste the output from running stress_32k (here called testkautuk)
here in case you haven't seen how elegant the oom-killer output is on
openrisc...

Thanks for the patch.

Acked-by: Jonas Bonn <jonas@southpole.se>

/Jonas


# testkautuk
testkautuk
message_alloc =20
message_alloc Thread 1=20
message_alloc =20
message_alloc Thread 1=20
message_alloc =20
message_alloc Thread 2=20
message_alloc =20
message_alloc Thread 2=20
message_alloc =20
message_alloc Thread 2=20
message_alloc =20
message_alloc Thread 2=20
message_alloc =20
message_alloc Thread 2=20
message_alloc =20
message_alloc Thread 2=20
message_alloc =20
message_alloc Thread 2=20
message_alloc =20
message_alloc Thread 2=20
testkautuk invoked oom-killer: gfp_mask=3D0x200da, order=3D0, oom_adj=3D0,
oom_score_adj=3D0
Stack dump [0xc1549ca8]:
sp + 00: 0xc01fdba0
sp + 04: 0xc005c110
sp + 08: 0xc1519a00
sp + 12: 0x000200da
sp + 16: 0x00000000
sp + 20: 0x00000000
sp + 24: 0x00000000
sp + 28: 0xc0245290
sp + 32: 0x00000000
sp + 36: 0xc1549d30
sp + 40: 0xc1530970
sp + 44: 0x00000000
sp + 48: 0xc1530970
sp + 52: 0x00000000
sp + 56: 0xc005c638
sp + 60: 0x00000000
sp + 64: 0x0000000c
sp + 68: 0x00000000
sp + 72: 0x00000000
sp + 76: 0x00000010
sp + 80: 0xc024cc6c
sp + 84: 0xc0213b92
sp + 88: 0xc0240000
sp + 92: 0xc1549d2c
sp + 96: 0x00000170
sp + 100: 0x00000eb2
sp + 104: 0x00000000
sp + 108: 0xc1530970
sp + 112: 0x000200da
sp + 116: 0x00000000
sp + 120: 0x00000000
sp + 124: 0xc005cc30
sp + 128: 0xc0213b92
sp + 132: 0xc0240098
sp + 136: 0x00000000
sp + 140: 0x000200da
sp + 144: 0xc024c6a8
sp + 148: 0xc024c6a8
sp + 152: 0x00000000
sp + 156: 0xc024cc60
sp + 160: 0x00000000
sp + 164: 0x00000040
sp + 168: 0x00000001
sp + 172: 0x00000000
sp + 176: 0x00000000
sp + 180: 0xc0061704
sp + 184: 0xc024c6a8
sp + 188: 0x00000000
sp + 192: 0xc024cc64
sp + 196: 0x00000000
sp + 200: 0x000200da
sp + 204: 0x00000000
sp + 208: 0x00000000
sp + 212: 0x00000040
sp + 216: 0x00000010
sp + 220: 0x00000000
sp + 224: 0x00000000
sp + 228: 0x00000050
sp + 232: 0x00000001
sp + 236: 0x00000000
sp + 240: 0x00000040
sp + 244: 0x00000001
sp + 248: 0x00000080
sp + 252: 0x00000000
sp + 256: 0x00000000
sp + 260: 0x00000000
sp + 264: 0x00000000
sp + 268: 0x00000000
sp + 272: 0xc024c6a8
sp + 276: 0xc024c6a8
sp + 280: 0x00000000
sp + 284: 0x00000001
sp + 288: 0xc15a7d00
sp + 292: 0x30b76000
sp + 296: 0xc1531080
sp + 300: 0x00000029
sp + 304: 0xc15440c0
sp + 308: 0xc15310b4
sp + 312: 0x00000001
sp + 316: 0x00030002
sp + 320: 0xc0078e34
sp + 324: 0xc14d1940
sp + 328: 0xc1530f00
sp + 332: 0x00000000
sp + 336: 0xc1531080
sp + 340: 0x00000000
sp + 344: 0xc1548000
sp + 348: 0xc14d1cac
sp + 352: 0xc15a7d00
sp + 356: 0x30b76000
sp + 360: 0x00000029
sp + 364: 0xc1519860
sp + 368: 0xc1549ef0
sp + 372: 0xc1531080
sp + 376: 0x00000300
sp + 380: 0xc15310b4
sp + 384: 0x00000001
sp + 388: 0x00030002
sp + 392: 0xc0007554
sp + 396: 0x30000000
sp + 400: 0xc0244064
sp + 404: 0xffffffff
sp + 408: 0x30b78000
sp + 412: 0xc1549e44
sp + 416: 0xc1549e44
sp + 420: 0x00030002
sp + 424: 0xc1549e70
sp + 428: 0x00000000
sp + 432: 0xc0242de0
sp + 436: 0xc03ecb40
sp + 440: 0x00000000
sp + 444: 0xc0240b70
sp + 448: 0x00000012
sp + 452: 0xc03ed94c
sp + 456: 0xc1549e70
sp + 460: 0xc1549e70
sp + 464: 0x00000000
sp + 468: 0xc03eca14
sp + 472: 0x00000100
sp + 476: 0x00000001
sp + 480: 0x0000000a
sp + 484: 0xc15529c4
sp + 488: 0x00000000
sp + 492: 0xc15da214
sp + 496: 0xc1549eb8
sp + 500: 0xc1519860
sp + 504: 0xc02438f0
sp + 508: 0xc1519cb0
sp + 512: 0xc02438f0
sp + 516: 0xc1530f00
sp + 520: 0xc1549ef0
sp + 524: 0xc01ff790
sp + 528: 0x00000002
sp + 532: 0x00000000
sp + 536: 0x00000000
sp + 540: 0x7f1ffe70
sp + 544: 0x00000000
sp + 548: 0x00000000
sp + 552: 0x00000000
sp + 556: 0x00000000
sp + 560: 0x00000803
sp + 564: 0x00000003
sp + 568: 0x00021680
sp + 572: 0x00000001
sp + 576: 0xffffffff
sp + 580: 0xc0004df0
sp + 584: 0x0000827e
sp + 588: 0x7f1ffd88
sp + 592: 0x7f1ffe70
sp + 596: 0x30b2c008
sp + 600: 0x00000001
sp + 604: 0x00080000
sp + 608: 0x30b75fe8
sp + 612: 0x01010101
sp + 616: 0x00001b01
sp + 620: 0x000004a4
sp + 624: 0x00000000
sp + 628: 0x00000000
sp + 632: 0x00018000
sp + 636: 0x000077e8
sp + 640: 0x00000000
sp + 644: 0x0000847e
sp + 648: 0x00000000
sp + 652: 0xfffffff9
sp + 656: 0x00000000
sp + 660: 0x00008079
sp + 664: 0x00000000
sp + 668: 0x00000001
sp + 672: 0x00000803
sp + 676: 0x00000000
sp + 680: 0x00000003
sp + 684: 0x5af23d90
sp + 688: 0x00021680
sp + 692: 0xfffffff9
sp + 696: 0x00000001
sp + 700: 0x00008079
sp + 704: 0x00000000
sp + 708: 0x8267ce93
sp + 712: 0x000099f4
sp + 716: 0xffffffff
sp + 720: 0xc03ffe60
sp + 724: 0xc03eea6c
sp + 728: 0x00000000
sp + 732: 0x00000000
sp + 736: 0x00000000
sp + 740: 0x00000000
sp + 744: 0x00000000
sp + 748: 0x00000000
sp + 752: 0x00000000
sp + 756: 0x00000000
sp + 760: 0x00000000
sp + 764: 0x00000000
sp + 768: 0x00000000
sp + 772: 0x00000000
sp + 776: 0x00000000
sp + 780: 0x00000000
sp + 784: 0x00000000
sp + 788: 0x00000000
sp + 792: 0x00000000
sp + 796: 0x00000000
sp + 800: 0x00000000
sp + 804: 0x00000000
sp + 808: 0x00000000
sp + 812: 0x00000000
sp + 816: 0x00000000
sp + 820: 0x00000000
sp + 824: 0x00000000
sp + 828: 0x00000000
sp + 832: 0x00000000
sp + 836: 0x00000000
sp + 840: 0x00000000
sp + 844: 0x00000000
sp + 848: 0x00000000
sp + 852: 0x00000000

 [<c01fdba0>]
 [<c005c110>]
 [<c005c638>]
 [<c005cc30>]
 [<c0061704>]
 [<c0078e34>]
 [<c0007554>]
 [<c01ff790>]
 [<c0004df0>]
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Mem-Info:
Normal per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
active_anon:2985 inactive_anon:0 isolated_anon:0
 active_file:0 inactive_file:21 isolated_file:32
 unevictable:492 dirty:0 writeback:0 unstable:0
 free:90 slab_reclaimable:0 slab_unreclaimable:0
 mapped:64 shmem:0 pagetables:0 bounce:0
Normal free:720kB min:720kB low:896kB high:1080kB active_anon:23880kB
inactive_anon:0kB active_file:0kB inactive_file:168kB unevictable:3936kB
isolated(anon):0kB isolated(file):256kB present:32640kB mlocked:0kB
dirty:0kB writeback:0kB mapped:512kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:0kB kernel_stack:256kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:524 all_unreclaimable? yes
lowmem_reserve[]: 0 0
Normal: 0*8kB 1*16kB 0*32kB 1*64kB 1*128kB 0*256kB 1*512kB 0*1024kB
0*2048kB 0*4096kB 0*8192kB =3D 720kB
545 total pagecache pages
4096 pages RAM
334 pages reserved
157 pages shared
3585 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[   94]     0    94      178       45   0       0             0 sh
[   95]     0    95      178       40   0       0             0 inetd
[  104]     0   104     1685     1495   0       0             0
testkautuk
[  105]     0   105     1685     1491   0       0             0
testkautuk
[  106]     0   106     1685     1491   0       0             0
testkautuk
[  107]     0   107     1685     1495   0       0             0
testkautuk
[  108]     0   108     1685     1495   0       0             0
testkautuk
[  109]     0   109     1685     1491   0       0             0
testkautuk
[  110]     0   110     1685     1495   0       0             0
testkautuk
[  111]     0   111     1685     1491   0       0             0
testkautuk
[  112]     0   112     1685     1495   0       0             0
testkautuk
[  113]     0   113     1685     1495   0       0             0
testkautuk
[  114]     0   114     1685     1491   0       0             0
testkautuk
[  115]     0   115     1685     1491   0       0             0
testkautuk
[  116]     0   116     1685     1495   0       0             0
testkautuk
[  117]     0   117     1685     1491   0       0             0
testkautuk
Out of memory: Kill process 104 (testkautuk) score 368 or sacrifice
child
Killed process 105 (testkautuk) total-vm:13480kB, anon-rss:11856kB,
file-rss:72kB
Kill process 106 (testkautuk) sharing same memory
Kill process 109 (testkautuk) sharing same memory
Kill process 111 (testkautuk) sharing same memory
Kill process 114 (testkautuk) sharing same memory
Kill process 115 (testkautuk) sharing same memory
Kill process 117 (testkautuk) sharing same memory
testkautuk invoked oom-killer: gfp_mask=3D0x200da, order=3D0, oom_adj=3D0,
oom_score_adj=3D0
Stack dump [0xc15c1ca8]:
sp + 00: 0xc01fdba0
sp + 04: 0xc005c110
sp + 08: 0xc1552b30
sp + 12: 0x000200da
sp + 16: 0x00000000
sp + 20: 0x00000000
sp + 24: 0x00000000
sp + 28: 0xc0245290
sp + 32: 0x00000000
sp + 36: 0xc15c1d30
sp + 40: 0xc1530970
sp + 44: 0x00000000
sp + 48: 0xc1530970
sp + 52: 0x00000000
sp + 56: 0xc005c638
sp + 60: 0x00000000
sp + 64: 0x0000000c
sp + 68: 0x00000000
sp + 72: 0x00000000
sp + 76: 0x00000010
sp + 80: 0xc024cc6c
sp + 84: 0xc0213b92
sp + 88: 0xc0240000
sp + 92: 0xc15c1d2c
sp + 96: 0x000002fd
sp + 100: 0x00000eb2
sp + 104: 0x00000000
sp + 108: 0xc1530970
sp + 112: 0x000200da
sp + 116: 0x00000000
sp + 120: 0x00000000
sp + 124: 0xc005cc30
sp + 128: 0xc0213b92
sp + 132: 0xc0240098
sp + 136: 0x00000000
sp + 140: 0x000200da
sp + 144: 0xc024c6a8
sp + 148: 0xc024c6a8
sp + 152: 0x00000000
sp + 156: 0xc024cc60
sp + 160: 0x00000000
sp + 164: 0x00000040
sp + 168: 0x00000001
sp + 172: 0x00000000
sp + 176: 0x00000000
sp + 180: 0xc0061704
sp + 184: 0xc024c6a8
sp + 188: 0x00000000
sp + 192: 0xc024cc64
sp + 196: 0x00000000
sp + 200: 0x000200da
sp + 204: 0x00000000
sp + 208: 0x00000000
sp + 212: 0x00000040
sp + 216: 0x00000010
sp + 220: 0x00000000
sp + 224: 0x00000000
sp + 228: 0x00000050
sp + 232: 0x00000001
sp + 236: 0x00000000
sp + 240: 0x00000040
sp + 244: 0x00000001
sp + 248: 0x00000080
sp + 252: 0x00000000
sp + 256: 0x00000000
sp + 260: 0x00000000
sp + 264: 0x00000000
sp + 268: 0x00000000
sp + 272: 0xc024c6a8
sp + 276: 0xc024c6a8
sp + 280: 0x00000000
sp + 284: 0x00000001
sp + 288: 0xc15a7d00
sp + 292: 0x316b4000
sp + 296: 0xc1531080
sp + 300: 0x00000029
sp + 304: 0xc15440c4
sp + 308: 0xc15310b4
sp + 312: 0x00000001
sp + 316: 0x00030002
sp + 320: 0xc0078e34
sp + 324: 0x00000000
sp + 328: 0xc1531080
sp + 332: 0x00000300
sp + 336: 0xc1531080
sp + 340: 0x00000001
sp + 344: 0xc15c0000
sp + 348: 0xc1552990
sp + 352: 0xc15a7d00
sp + 356: 0x316b4000
sp + 360: 0x00000029
sp + 364: 0xc1552990
sp + 368: 0xc15c1ef0
sp + 372: 0xc1531080
sp + 376: 0x00000300
sp + 380: 0xc15310b4
sp + 384: 0x00000001
sp + 388: 0x00030002
sp + 392: 0xc0007554
sp + 396: 0x30000000
sp + 400: 0xc0244064
sp + 404: 0xffffffff
sp + 408: 0x316b6000
sp + 412: 0xc03ecb40
sp + 416: 0xc03eca14
sp + 420: 0x00030002
sp + 424: 0xc0242de0
sp + 428: 0x0000000a
sp + 432: 0xc03eca00
sp + 436: 0xc03ecb40
sp + 440: 0x00000000
sp + 444: 0xc0240b70
sp + 448: 0x00000017
sp + 452: 0xc03ed94c
sp + 456: 0xc15c1e70
sp + 460: 0xc15c1e70
sp + 464: 0x00000000
sp + 468: 0xc03eca14
sp + 472: 0x00000100
sp + 476: 0x00000001
sp + 480: 0x0000000a
sp + 484: 0xc15529bc
sp + 488: 0x00000000
sp + 492: 0xc15da214
sp + 496: 0xc15c1eb8
sp + 500: 0xc1552990
sp + 504: 0xc02438f0
sp + 508: 0xc1552540
sp + 512: 0xc02438f0
sp + 516: 0xc1531080
sp + 520: 0xc15c1ef0
sp + 524: 0xc01ff790
sp + 528: 0x00000002
sp + 532: 0x00000000
sp + 536: 0x00000000
sp + 540: 0x7edffe70
sp + 544: 0x00000000
sp + 548: 0x00000000
sp + 552: 0x00000000
sp + 556: 0x00000000
sp + 560: 0x00001005
sp + 564: 0x00000005
sp + 568: 0x00021680
sp + 572: 0x00000001
sp + 576: 0xffffffff
sp + 580: 0xc0004df0
sp + 584: 0x0000827e
sp + 588: 0x7edffd88
sp + 592: 0x7edffe70
sp + 596: 0x31658008
sp + 600: 0x00000001
sp + 604: 0x00080000
sp + 608: 0x316b3fe8
sp + 612: 0x01010101
sp + 616: 0x00001201
sp + 620: 0x0000078c
sp + 624: 0x00000000
sp + 628: 0x00000000
sp + 632: 0x00018000
sp + 636: 0x000077e8
sp + 640: 0x00000000
sp + 644: 0x0000847e
sp + 648: 0x00000000
sp + 652: 0xfffffff9
sp + 656: 0x00000000
sp + 660: 0x00008079
sp + 664: 0x00000000
sp + 668: 0x00000001
sp + 672: 0x00001005
sp + 676: 0x00000000
sp + 680: 0x00000005
sp + 684: 0x5af23d90
sp + 688: 0x00021680
sp + 692: 0xfffffff9
sp + 696: 0x00000001
sp + 700: 0x00008079
sp + 704: 0x00000000
sp + 708: 0x8267ce93
sp + 712: 0x000099f4
sp + 716: 0xffffffff
sp + 720: 0xc03ffe60
sp + 724: 0xc03eea6c
sp + 728: 0x00000000
sp + 732: 0x00000000
sp + 736: 0x00000000
sp + 740: 0x00000000
sp + 744: 0x00000000
sp + 748: 0x00000000
sp + 752: 0x00000000
sp + 756: 0x00000000
sp + 760: 0x00000000
sp + 764: 0x00000000
sp + 768: 0x00000000
sp + 772: 0x00000000
sp + 776: 0x00000000
sp + 780: 0x00000000
sp + 784: 0x00000000
sp + 788: 0x00000000
sp + 792: 0x00000000
sp + 796: 0x00000000
sp + 800: 0x00000000
sp + 804: 0x00000000
sp + 808: 0x00000000
sp + 812: 0x00000000
sp + 816: 0x00000000
sp + 820: 0x00000000
sp + 824: 0x00000000
sp + 828: 0x00000000
sp + 832: 0x00000000
sp + 836: 0x00000000
sp + 840: 0x00000000
sp + 844: 0x00000000
sp + 848: 0x00000000
sp + 852: 0x00000000

 [<c01fdba0>]
 [<c005c110>]
 [<c005c638>]
 [<c005cc30>]
 [<c0061704>]
 [<c0078e34>]
 [<c0007554>]
 [<c01ff790>]
 [<c0004df0>]
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Mem-Info:
Normal per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
active_anon:2996 inactive_anon:0 isolated_anon:0
 active_file:0 inactive_file:0 isolated_file:0
 unevictable:545 dirty:0 writeback:0 unstable:0
 free:90 slab_reclaimable:0 slab_unreclaimable:0
 mapped:64 shmem:0 pagetables:0 bounce:0
Normal free:720kB min:720kB low:896kB high:1080kB active_anon:23968kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:4360kB
isolated(anon):0kB isolated(file):0kB present:32640kB mlocked:0kB
dirty:0kB writeback:0kB mapped:512kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:0kB kernel_stack:208kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 0
Normal: 0*8kB 1*16kB 0*32kB 1*64kB 1*128kB 0*256kB 1*512kB 0*1024kB
0*2048kB 0*4096kB 0*8192kB =3D 720kB
545 total pagecache pages
4096 pages RAM
334 pages reserved
116 pages shared
3608 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[   94]     0    94      178       45   0       0             0 sh
[   95]     0    95      178       40   0       0             0 inetd
[  104]     0   104     3180     2988   0       0             0
testkautuk
[  107]     0   107     3180     2988   0       0             0
testkautuk
[  108]     0   108     3180     2988   0       0             0
testkautuk
[  110]     0   110     3180     2988   0       0             0
testkautuk
[  112]     0   112     3180     2988   0       0             0
testkautuk
[  113]     0   113     3180     2988   0       0             0
testkautuk
[  116]     0   116     3180     2988   0       0             0
testkautuk
Out of memory: Kill process 104 (testkautuk) score 765 or sacrifice
child
Killed process 104 (testkautuk) total-vm:25440kB, anon-rss:23832kB,
file-rss:72kB
Kill process 107 (testkautuk) sharing same memory
Kill process 108 (testkautuk) sharing same memory
Kill process 110 (testkautuk) sharing same memory
Kill process 112 (testkautuk) sharing same memory
Kill process 113 (testkautuk) sharing same memory
Kill process 116 (testkautuk) sharing same memory
Killed

--------- <END OF OUTPUT> --------------

On Sat, 2012-03-31 at 08:00 -0400, Kautuk Consul wrote:
> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> (mm: retry page fault when blocking on disk transfer) and
> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> (x86,mm: make pagefault killable)
>=20
> The above commits introduced changes into the x86 pagefault handler
> for making the page fault handler retryable as well as killable.
>=20
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
>=20
> Port these changes to openrisc.
>=20
> Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  arch/openrisc/mm/fault.c |   32 ++++++++++++++++++++++++++------
>  1 files changed, 26 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/openrisc/mm/fault.c b/arch/openrisc/mm/fault.c
> index a5dce82..40f850e 100644
> --- a/arch/openrisc/mm/fault.c
> +++ b/arch/openrisc/mm/fault.c
> @@ -54,6 +54,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, uns=
igned long address,
>  	struct vm_area_struct *vma;
>  	siginfo_t info;
>  	int fault;
> +	unsigned int flags =3D FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> =20
>  	tsk =3D current;
> =20
> @@ -105,6 +106,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, u=
nsigned long address,
>  	if (in_interrupt() || !mm)
>  		goto no_context;
> =20
> +retry:
>  	down_read(&mm->mmap_sem);
>  	vma =3D find_vma(mm, address);
> =20
> @@ -143,6 +145,7 @@ good_area:
>  	if (write_acc) {
>  		if (!(vma->vm_flags & VM_WRITE))
>  			goto bad_area;
> +		flags |=3D FAULT_FLAG_WRITE;
>  	} else {
>  		/* not present */
>  		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
> @@ -159,7 +162,11 @@ good_area:
>  	 * the fault.
>  	 */
> =20
> -	fault =3D handle_mm_fault(mm, vma, address, write_acc);
> +	fault =3D handle_mm_fault(mm, vma, address, flags);
> +
> +	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
> +		return;
> +
>  	if (unlikely(fault & VM_FAULT_ERROR)) {
>  		if (fault & VM_FAULT_OOM)
>  			goto out_of_memory;
> @@ -167,11 +174,24 @@ good_area:
>  			goto do_sigbus;
>  		BUG();
>  	}
> -	/*RGD modeled on Cris */
> -	if (fault & VM_FAULT_MAJOR)
> -		tsk->maj_flt++;
> -	else
> -		tsk->min_flt++;
> +
> +	if (flags & FAULT_FLAG_ALLOW_RETRY) {
> +		/*RGD modeled on Cris */
> +		if (fault & VM_FAULT_MAJOR)
> +			tsk->maj_flt++;
> +		else
> +			tsk->min_flt++;
> +		if (fault & VM_FAULT_RETRY) {
> +			flags &=3D ~FAULT_FLAG_ALLOW_RETRY;
> +
> +			 /* No need to up_read(&mm->mmap_sem) as we would
> +			 * have already released it in __lock_page_or_retry
> +			 * in mm/filemap.c.
> +			 */
> +
> +			goto retry;
> +		}
> +	}
> =20
>  	up_read(&mm->mmap_sem);
>  	return;


--=-dq5ywcll13kiQnWeaJ2V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9/HMAACgkQ70gcjN2673ODHwCgkv3XBkgQve3tdz+Hi+EdfVQm
Ih0AoIKu1BYml+0I0e7crdqeKK6Nieuk
=Q3CA
-----END PGP SIGNATURE-----

--=-dq5ywcll13kiQnWeaJ2V--

