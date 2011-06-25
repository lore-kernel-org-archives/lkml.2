Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1FYTZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 15:25:49 -0400
Received: from wnohang.net ([178.79.154.173]:35926 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab1FYTZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 15:25:45 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jun 2011 15:25:44 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 9216BF0004
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 39E23F0003
Date: Sun, 26 Jun 2011 00:49:29 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: laurent.pinchart@ideasonboard.com
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Oops while modprobing uvcvideo module
Message-ID: <20110625191929.GA4411@Xye>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
X-Operating-System: Arch linux x86_64 3.0.0-rc4-LYM
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

     While modprobing uvcvideo I am getting the following oops. This is
     on a kernel built with latest linus master
     (536142f950f7ea4f3d146a138ad6938f28a34f33). I have also attached the
     full dmesg.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  [ 1985.732475] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_2=
HDM (0408:2fb1)
  [ 1985.759844] uvcvideo: No streaming interface found for terminal 6.
  [ 1985.759863] BUG: unable to handle kernel NULL pointer dereference at 0=
000000000000050
  [ 1985.759871] IP: [<ffffffffa0da23e0>] media_entity_init+0x40/0xa0 [medi=
a]
  [ 1985.759884] PGD 10f9eb067 PUD 1397ce067 PMD 0
  [ 1985.759892] Oops: 0002 [#1] PREEMPT SMP
  [ 1985.759899] CPU 0
  [ 1985.759901] Modules linked in: uvcvideo(+) videodev v4l2_compat_ioctl3=
2 media nbd kvm_intel kvm usb_storage cls_u32 sch_sfb sch_htb max6650 coret=
emp usbhid snd_hda_codec_hdmi snd_hda_codec_realtek iwlagn snd_hda_intel ma=
c80211 snd_hda_c odec nvidia(P) snd_pcm cfg80211 dell_laptop rfkill ehci_hc=
d snd_timer iTCO_wdt dell_wmi snd soundcore snd_page_alloc psmouse sparse_k=
eymap mei(C) i7core_edac edac_core dcdbas intel_ips xhci_hcd iTCO_vendor_su=
pport wmi usbcore agpgart sd_mo d ahci libahci
  [ 1985.759961]
  [ 1985.759967] Pid: 14596, comm: modprobe Tainted: P         C  3.0.0-rc4=
-LYM #8 Dell Inc. XPS L501X  /0J1VR3
  [ 1985.759975] RIP: 0010:[<ffffffffa0da23e0>]  [<ffffffffa0da23e0>] media=
_entity_init+0x40/0xa0 [media]
  [ 1985.759986] RSP: 0018:ffff88013a657bc8  EFLAGS: 00010282
  [ 1985.759990] RAX: ffff880126cfd6e0 RBX: 0000000000000000 RCX: 000000000=
0000000
  [ 1985.759995] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88012=
6cfd700
  [ 1985.760000] RBP: ffff88013a657bf8 R08: 0000000000000000 R09: ffff88012=
6cfd6e0
  [ 1985.760004] R10: 0000000000000000 R11: 0000000000000001 R12: 000000000=
0000001
  [ 1985.760008] R13: ffff8800b18c7d58 R14: 0000000000000001 R15: 000000000=
0000001
  [ 1985.760014] FS:  00007f7cb0722700(0000) GS:ffff88013fc00000(0000) knlG=
S:0000000000000000
  [ 1985.760019] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  [ 1985.760024] CR2: 0000000000000050 CR3: 0000000132f04000 CR4: 000000000=
00006f0
  [ 1985.760029] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
  [ 1985.760034] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
  [ 1985.760039] Process modprobe (pid: 14596, threadinfo ffff88013a656000,=
 task ffff88013940c920)
  [ 1985.760043] Stack:
  [ 1985.760046]  ffff8800b76fac00 ffff8800b18c7800 ffff8800b18c7070 ffff88=
00b7679d80
  [ 1985.760055]  ffff8800b7679d98 0000000000000000 ffff88013a657c38 ffffff=
ffa0df211a
  [ 1985.760063]  ffff88013a657c38 ffff8800b7679d88 ffff8800b18c0cc0 ffff88=
00b18c0800
  [ 1985.760072] Call Trace:
  [ 1985.760086]  [<ffffffffa0df211a>] uvc_mc_register_entities+0xba/0x25c =
[uvcvideo]
  [ 1985.760100]  [<ffffffffa0de8a48>] uvc_probe+0x388/0x2550 [uvcvideo]
  [ 1985.760128]  [<ffffffffa0047ed3>] usb_probe_interface+0xf3/0x250 [usbc=
ore]
  [ 1985.760138]  [<ffffffff81425bfc>] driver_probe_device+0x9c/0x2b0
  [ 1985.760144]  [<ffffffff81425ebb>] __driver_attach+0xab/0xb0
  [ 1985.760151]  [<ffffffff81425e10>] ? driver_probe_device+0x2b0/0x2b0
  [ 1985.760157]  [<ffffffff81425e10>] ? driver_probe_device+0x2b0/0x2b0
  [ 1985.760165]  [<ffffffff81424a0c>] bus_for_each_dev+0x5c/0x90
  [ 1985.760173]  [<ffffffff8142580e>] driver_attach+0x1e/0x20
  [ 1985.760179]  [<ffffffff81425410>] bus_add_driver+0x1b0/0x2a0
  [ 1985.760186]  [<ffffffff814263f6>] driver_register+0x76/0x140
  [ 1985.760205]  [<ffffffffa0046cbd>] usb_register_driver+0x9d/0x190 [usbc=
ore]
  [ 1985.760213]  [<ffffffffa0dba000>] ? 0xffffffffa0db9fff
  [ 1985.760224]  [<ffffffffa0dba020>] uvc_init+0x20/0x1000 [uvcvideo]
  [ 1985.760234]  [<ffffffff810001d0>] do_one_initcall+0x40/0x170
  [ 1985.760243]  [<ffffffff8108494e>] sys_init_module+0xbe/0x230
  [ 1985.760252]  [<ffffffff815881eb>] system_call_fastpath+0x16/0x1b
  [ 1985.760256] Code: 90 44 0f b7 f6 44 0f b7 f9 48 89 fb 45 01 f7 41 89 f=
4 be d0 80 00 00 44 89 ff 49 89 d5 48 c1 e7 05 e8 35 60 38 e0 48 85 c0 74 56
  [ 1985.760296]  89 43 50 31 c0 45 85 f6 c7 43 38 00 00 00 00 66 44 89 7b =
42
  [ 1985.760315] RIP  [<ffffffffa0da23e0>] media_entity_init+0x40/0xa0 [med=
ia]
  [ 1985.760325]  RSP <ffff88013a657bc8>
  [ 1985.760328] CR2: 0000000000000050
  [ 1985.760383] ---[ end trace d9254fd075095138 ]---
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I was able to observe this at boot and also reproduce it later.

Further analyzing the oops revealed this:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
perl scripts/markup_oops.pl < ~/oops

No vmlinux specified, assuming /lib/modules/3.0.0-rc4-LYM/build/vmlinux
         unsigned int max_links =3D num_pads + extra_links;
         unsigned int i;

         links =3D kzalloc(max_links * sizeof(links[0]), GFP_KERNEL);
  ffffffffa01573d2:      48 c1 e7 05             shl    $0x5,%rdi   |  %edi=
 =3D> ffff88013ac31200
  ffffffffa01573d6:      e8 00 00 00 00          callq  ffffffffa01573db <m=
edia_entity_init+0x3b>
         if (links =3D=3D NULL)
  ffffffffa01573db:      48 85 c0                test   %rax,%rax   |  %eax=
 =3D> ffff88013ac311e0
  ffffffffa01573de:      74 56                   je     ffffffffa0157436 <m=
edia_entity_init+0x96>
         entity->max_links =3D max_links;
         entity->num_links =3D 0;
         entity->num_backlinks =3D 0;
         entity->num_pads =3D num_pads;
         entity->pads =3D pads;
         entity->links =3D links;
*ffffffffa01573e0:      48 89 43 50             mov    %rax,0x50(%rbx) |  %=
eax =3D ffff88013ac311e0 <--- faulting instruction
         for (i =3D 0; i < num_pads; i++) {
                 pads[i].entity =3D entity;
                 pads[i].index =3D i;
         }

         return 0;
  ffffffffa01573e4:      31 c0                   xor    %eax,%eax
         entity->num_backlinks =3D 0;
         entity->num_pads =3D num_pads;
         entity->pads =3D pads;
         entity->links =3D links;
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

gcc --version=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
gcc (GCC) 4.6.0 20110603 (prerelease)
Copyright (C) 2011 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Currently I have blacklisted the uvcvideo, so it is not hampering normal
operation of the system.

--------------------------
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="oops.dmesg"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc4-LYM (raghavendra@Xye) (gcc version 4=
=2E6.0 20110603 (prerelease) (GCC) ) #8 SMP PREEMPT Sat Jun 25 21:37:57 IST=
 2011
[    0.000000] Command line: root=3D/dev/sda6 ro vga=3D773
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
[    0.000000]  BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bba7c000 (usable)
[    0.000000]  BIOS-e820: 00000000bba7c000 - 00000000bba82000 (reserved)
[    0.000000]  BIOS-e820: 00000000bba82000 - 00000000bbbd7000 (usable)
[    0.000000]  BIOS-e820: 00000000bbbd7000 - 00000000bbc0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bbc0f000 - 00000000bbc5d000 (usable)
[    0.000000]  BIOS-e820: 00000000bbc5d000 - 00000000bbc5e000 (reserved)
[    0.000000]  BIOS-e820: 00000000bbc5e000 - 00000000bbcdf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bbcdf000 - 00000000bbf0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bbf0f000 - 00000000bbf18000 (usable)
[    0.000000]  BIOS-e820: 00000000bbf18000 - 00000000bbf1f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bbf1f000 - 00000000bbf79000 (usable)
[    0.000000]  BIOS-e820: 00000000bbf79000 - 00000000bbf9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bbf9f000 - 00000000bbfe2000 (usable)
[    0.000000]  BIOS-e820: 00000000bbfe2000 - 00000000bbfff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bbfff000 - 00000000bc000000 (usable)
[    0.000000]  BIOS-e820: 00000000bc000000 - 00000000be000000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf800000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0a05000 - 00000000f0a06000 (reserved)
[    0.000000]  BIOS-e820: 00000000feaff000 - 00000000feb00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Dell Inc. XPS L501X  /0J1VR3, BIOS A07 03/29/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] last_pfn =3D 0x140000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFDC0000 mask FFFFC0000 write-protect
[    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BC000000 mask FFE000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] last_pfn =3D 0xbc000 max_arch_pfn =3D 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bc000000
[    0.000000]  0000000000 - 00bc000000 page 2M
[    0.000000] kernel direct mapping tables up to bc000000 @ bbfde000-bbfe2=
000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ 13fffa000-140=
000000
[    0.000000] RAMDISK: 37edd000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f6ca0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000bbff47b3 0006C (v01 DELL    QA09    06040=
000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bbfe4000 000F4 (v03 INTEL  CALPELLA 06040=
000 PTEC 00000001)
[    0.000000] ACPI: DSDT 00000000bbfe5000 0A263 (v02 Intel  CALPELLA 06040=
000 INTL 20060912)
[    0.000000] ACPI: FACS 00000000bbf9bfc0 00040
[    0.000000] ACPI: HPET 00000000bbffec22 00038 (v01 INTEL  CALPELLA 06040=
000 PTEC 00000001)
[    0.000000] ACPI: MCFG 00000000bbffec5a 0003C (v01 INTEL  CALPELLA 06040=
000 PTEC 00000001)
[    0.000000] ACPI: APIC 00000000bbffec96 000BC (v01 PTLTD  ? APIC   06040=
000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bbffed52 00028 (v01 PTLTD  $SBFTBL$ 06040=
000  LTP 00000001)
[    0.000000] ACPI: SLIC 00000000bbffed7a 00176 (v01 DELL    QA09    06040=
000  LTP 00000000)
[    0.000000] ACPI: OSFR 00000000bbffeef0 00070 (v01 DELL   DELL     06040=
000 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000bbffef60 000A0 (v16   CETP     CETP 06040=
000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bbfe3000 009F1 (v01  PmRef    CpuPm 00003=
000 INTL 20060912)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88013b60000=
0-ffff88013edfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[9] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009c
[    0.000000]     0: 0x00000100 -> 0x000bba7c
[    0.000000]     0: 0x000bba82 -> 0x000bbbd7
[    0.000000]     0: 0x000bbc0f -> 0x000bbc5d
[    0.000000]     0: 0x000bbf0f -> 0x000bbf18
[    0.000000]     0: 0x000bbf1f -> 0x000bbf79
[    0.000000]     0: 0x000bbf9f -> 0x000bbfe2
[    0.000000]     0: 0x000bbfff -> 0x000bc000
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1031250
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3919 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 750846 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000=
:20000000)
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:8 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88013fc00000 s72128 r8192=
 d22080 u262144
[    0.000000] pcpu-alloc: s72128 r8192 d22080 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 1013325
[    0.000000] Kernel command line: root=3D/dev/sda6 ro vga=3D773
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.000000] Memory: 3979736k/5242880k available (5678k kernel code, 1117=
880k absent, 145264k reserved, 5357k data, 652k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D8, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:768
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 1728.783 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 3457.56 BogoMIPS (lpj=3D1728783)
[    0.000015] pid_max: default: 32768 minimum: 301
[    0.000138] Mount-cache hash table entries: 256
[    0.000360] Initializing cgroup subsys debug
[    0.000366] Initializing cgroup subsys cpuacct
[    0.000384] Initializing cgroup subsys freezer
[    0.000389] Initializing cgroup subsys blkio
[    0.000397] Initializing cgroup subsys perf_event
[    0.000437] CPU: Physical Processor ID: 0
[    0.000442] CPU: Processor Core ID: 0
[    0.000449] mce: CPU supports 9 MCE banks
[    0.000461] CPU0: Thermal monitoring handled by SMI
[    0.000468] using mwait in idle threads.
[    0.000535] ACPI: Core revision 20110413
[    0.016051] ftrace: allocating 19772 entries in 78 pages
[    0.024329] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.034331] CPU0: Intel(R) Core(TM) i7 CPU       Q 740  @ 1.73GHz steppi=
ng 05
[    0.136100] Performance Events: PEBS fmt1+, erratum AAJ80 worked around,=
 Nehalem events, Intel PMU driver.
[    0.136113] ... version:                3
[    0.136117] ... bit width:              48
[    0.136121] ... generic registers:      4
[    0.136125] ... value mask:             0000ffffffffffff
[    0.136130] ... max period:             000000007fffffff
[    0.136134] ... fixed-purpose events:   3
[    0.136138] ... event mask:             000000070000000f
[    0.144261] NMI watchdog enabled, takes one hw-pmu counter.
[    0.152125] Booting Node   0, Processors  #1
[    0.152136] smpboot cpu 1: start_ip =3D 97000
[    0.223082] CPU1: Thermal monitoring handled by SMI
[    0.243206] NMI watchdog enabled, takes one hw-pmu counter.
[    0.249088]  #2
[    0.249094] smpboot cpu 2: start_ip =3D 97000
[    0.320033] CPU2: Thermal monitoring handled by SMI
[    0.340156] NMI watchdog enabled, takes one hw-pmu counter.
[    0.346038]  #3
[    0.346044] smpboot cpu 3: start_ip =3D 97000
[    0.416983] CPU3: Thermal monitoring handled by SMI
[    0.437108] NMI watchdog enabled, takes one hw-pmu counter.
[    0.442987]  #4
[    0.442993] smpboot cpu 4: start_ip =3D 97000
[    0.513934] CPU4: Thermal monitoring handled by SMI
[    0.534023] NMI watchdog enabled, takes one hw-pmu counter.
[    0.539942]  #5
[    0.539948] smpboot cpu 5: start_ip =3D 97000
[    0.610886] CPU5: Thermal monitoring handled by SMI
[    0.630921] NMI watchdog enabled, takes one hw-pmu counter.
[    0.636920]  #6
[    0.636925] smpboot cpu 6: start_ip =3D 97000
[    0.707865] CPU6: Thermal monitoring handled by SMI
[    0.727995] NMI watchdog enabled, takes one hw-pmu counter.
[    0.733900]  #7 Ok.
[    0.733907] smpboot cpu 7: start_ip =3D 97000
[    0.804839] CPU7: Thermal monitoring handled by SMI
[    0.824879] NMI watchdog enabled, takes one hw-pmu counter.
[    0.826829] Brought up 8 CPUs
[    0.826839] Total of 8 processors activated (27659.39 BogoMIPS).
[    0.831469] print_constraints: dummy:=20
[    0.831525] NET: Registered protocol family 16
[    0.831973] ACPI: bus type pci registered
[    0.832090] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.832099] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.904967] PCI: Using configuration type 1 for base access
[    0.907807] bio: create slab <bio-0> at 0
[    0.909584] ACPI: EC: Look up EC in DSDT
[    0.918874] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.919687] ACPI: SSDT 00000000bbf1aa98 0032A (v01  PmRef  Cpu0Ist 00003=
000 INTL 20060912)
[    0.920083] ACPI: Dynamic OEM Table Load:
[    0.920090] ACPI: SSDT           (null) 0032A (v01  PmRef  Cpu0Ist 00003=
000 INTL 20060912)
[    0.920269] ACPI: SSDT 00000000bbf19018 008B0 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20060912)
[    0.920636] ACPI: Dynamic OEM Table Load:
[    0.920642] ACPI: SSDT           (null) 008B0 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20060912)
[    0.926145] ACPI: SSDT 00000000bbf1a718 00303 (v01  PmRef    ApIst 00003=
000 INTL 20060912)
[    0.926584] ACPI: Dynamic OEM Table Load:
[    0.926590] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003=
000 INTL 20060912)
[    0.929085] ACPI: SSDT 00000000bbf18d98 00119 (v01  PmRef    ApCst 00003=
000 INTL 20060912)
[    0.929484] ACPI: Dynamic OEM Table Load:
[    0.929490] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20060912)
[    0.933387] ACPI: Interpreter enabled
[    0.933394] ACPI: (supports S0 S3 S5)
[    0.933416] ACPI: Using IOAPIC for interrupt routing
[    0.941468] ACPI: Power Resource [FN00] (off)
[    0.941600] ACPI: Power Resource [FN01] (off)
[    0.942190] ACPI: EC: GPE =3D 0x16, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.942269] HEST: Table not found.
[    0.942275] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.942764] \_SB_.PCI0:_OSC invalid UUID
[    0.942766] _OSC request data:1 8 1f=20
[    0.942770] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.943572] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.943579] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.943586] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.943593] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x00=
0d3fff]
[    0.943600] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff]
[    0.943607] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff]
[    0.943614] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x00=
0dffff]
[    0.943622] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdf=
ffffff]
[    0.943629] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfe=
bfffff]
[    0.943648] pci 0000:00:00.0: [8086:d132] type 0 class 0x000600
[    0.943704] pci 0000:00:03.0: [8086:d138] type 1 class 0x000604
[    0.943748] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.943752] pci 0000:00:03.0: PME# disabled
[    0.943773] pci 0000:00:08.0: [8086:d155] type 0 class 0x000880
[    0.943831] pci 0000:00:08.1: [8086:d156] type 0 class 0x000880
[    0.943888] pci 0000:00:08.2: [8086:d157] type 0 class 0x000880
[    0.943944] pci 0000:00:08.3: [8086:d158] type 0 class 0x000880
[    0.944008] pci 0000:00:10.0: [8086:d150] type 0 class 0x000880
[    0.944059] pci 0000:00:10.1: [8086:d151] type 0 class 0x000880
[    0.944144] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.944175] pci 0000:00:16.0: reg 10: [mem 0xf0a06800-0xf0a0680f 64bit]
[    0.944252] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.944261] pci 0000:00:16.0: PME# disabled
[    0.944307] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.944333] pci 0000:00:1a.0: reg 10: [mem 0xf0a07000-0xf0a073ff]
[    0.944416] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.944425] pci 0000:00:1a.0: PME# disabled
[    0.944466] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.944486] pci 0000:00:1b.0: reg 10: [mem 0xf0a00000-0xf0a03fff 64bit]
[    0.944551] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.944560] pci 0000:00:1b.0: PME# disabled
[    0.944588] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.944654] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.944662] pci 0000:00:1c.0: PME# disabled
[    0.944692] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    0.944757] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.944766] pci 0000:00:1c.1: PME# disabled
[    0.944801] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    0.944866] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.944875] pci 0000:00:1c.3: PME# disabled
[    0.944908] pci 0000:00:1c.4: [8086:3b4a] type 1 class 0x000604
[    0.944979] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.944988] pci 0000:00:1c.4: PME# disabled
[    0.945025] pci 0000:00:1c.5: [8086:3b4c] type 1 class 0x000604
[    0.945091] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.945099] pci 0000:00:1c.5: PME# disabled
[    0.945142] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.945168] pci 0000:00:1d.0: reg 10: [mem 0xf0a07400-0xf0a077ff]
[    0.945252] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.945261] pci 0000:00:1d.0: PME# disabled
[    0.945293] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.945368] pci 0000:00:1f.0: [8086:3b0b] type 0 class 0x000601
[    0.945505] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    0.945530] pci 0000:00:1f.2: reg 10: [io  0x1818-0x181f]
[    0.945543] pci 0000:00:1f.2: reg 14: [io  0x180c-0x180f]
[    0.945556] pci 0000:00:1f.2: reg 18: [io  0x1810-0x1817]
[    0.945569] pci 0000:00:1f.2: reg 1c: [io  0x1808-0x180b]
[    0.945582] pci 0000:00:1f.2: reg 20: [io  0x1820-0x183f]
[    0.945595] pci 0000:00:1f.2: reg 24: [mem 0xf0a06000-0xf0a067ff]
[    0.945639] pci 0000:00:1f.2: PME# supported from D3hot
[    0.945647] pci 0000:00:1f.2: PME# disabled
[    0.945682] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.945702] pci 0000:00:1f.3: reg 10: [mem 0xf0a07800-0xf0a078ff 64bit]
[    0.945729] pci 0000:00:1f.3: reg 20: [io  0x1840-0x185f]
[    0.945778] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.945807] pci 0000:00:1f.6: reg 10: [mem 0xf0a05000-0xf0a05fff 64bit]
[    0.945927] pci 0000:02:00.0: [10de:0df2] type 0 class 0x000300
[    0.945939] pci 0000:02:00.0: reg 10: [mem 0xcc000000-0xccffffff]
[    0.945950] pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit p=
ref]
[    0.945962] pci 0000:02:00.0: reg 1c: [mem 0xce000000-0xcfffffff 64bit p=
ref]
[    0.945969] pci 0000:02:00.0: reg 24: [io  0x2000-0x207f]
[    0.945977] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.946022] pci 0000:02:00.1: [10de:0bea] type 0 class 0x000403
[    0.946032] pci 0000:02:00.1: reg 10: [mem 0xcdefc000-0xcdefffff]
[    0.948048] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.948056] pci 0000:00:03.0:   bridge window [io  0x2000-0x2fff]
[    0.948059] pci 0000:00:03.0:   bridge window [mem 0xcc000000-0xcdefffff]
[    0.948065] pci 0000:00:03.0:   bridge window [mem 0xce000000-0xdfffffff=
 64bit pref]
[    0.948115] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.948127] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.948136] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.948147] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.948439] pci 0000:04:00.0: [8086:422c] type 0 class 0x000280
[    0.948709] pci 0000:04:00.0: reg 10: [mem 0xf0500000-0xf0501fff 64bit]
[    0.949752] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.949783] pci 0000:04:00.0: PME# disabled
[    0.950217] pci 0000:00:1c.1: PCI bridge to [bus 04-04]
[    0.950229] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.950238] pci 0000:00:1c.1:   bridge window [mem 0xf0500000-0xf05fffff]
[    0.950249] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.950395] pci 0000:05:00.0: [1033:0194] type 0 class 0x000c03
[    0.950504] pci 0000:05:00.0: reg 10: [mem 0xf0600000-0xf0601fff 64bit]
[    0.950971] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.950986] pci 0000:05:00.0: PME# disabled
[    0.951186] pci 0000:00:1c.3: PCI bridge to [bus 05-06]
[    0.951198] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.951207] pci 0000:00:1c.3:   bridge window [mem 0xf0600000-0xf06fffff]
[    0.951218] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff=
 64bit pref]
[    0.951268] pci 0000:00:1c.4: PCI bridge to [bus 07-08]
[    0.951280] pci 0000:00:1c.4:   bridge window [io  0x4000-0x4fff]
[    0.951289] pci 0000:00:1c.4:   bridge window [mem 0xf0700000-0xf07fffff]
[    0.951300] pci 0000:00:1c.4:   bridge window [mem 0xf0200000-0xf03fffff=
 64bit pref]
[    0.951370] pci 0000:09:00.0: [10ec:8168] type 0 class 0x000200
[    0.951391] pci 0000:09:00.0: reg 10: [io  0x5000-0x50ff]
[    0.951425] pci 0000:09:00.0: reg 18: [mem 0xf0404000-0xf0404fff 64bit p=
ref]
[    0.951448] pci 0000:09:00.0: reg 20: [mem 0xf0400000-0xf0403fff 64bit p=
ref]
[    0.951507] pci 0000:09:00.0: supports D1 D2
[    0.951509] pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.951518] pci 0000:09:00.0: PME# disabled
[    0.953095] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.953107] pci 0000:00:1c.5:   bridge window [io  0x5000-0x5fff]
[    0.953116] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.953127] pci 0000:00:1c.5:   bridge window [mem 0xf0400000-0xf04fffff=
 64bit pref]
[    0.953203] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive dec=
ode)
[    0.953216] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.953225] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.953236] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.953239] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtr=
active decode)
[    0.953242] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtr=
active decode)
[    0.953244] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)
[    0.953247] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff=
] (subtractive decode)
[    0.953250] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff=
] (subtractive decode)
[    0.953253] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff=
] (subtractive decode)
[    0.953255] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff=
] (subtractive decode)
[    0.953258] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff=
] (subtractive decode)
[    0.953261] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff=
] (subtractive decode)
[    0.953299] pci_bus 0000:00: on NUMA node 0
[    0.953303] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.953514] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.953568] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.953680] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.953738] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.953796] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.953849] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.953922] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.954013] \_SB_.PCI0:_OSC invalid UUID
[    0.954015] _OSC request data:1 1f 1f=20
[    0.954020]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.954068] \_SB_.PCI0:_OSC invalid UUID
[    0.954069] _OSC request data:1 0 1d=20
[    0.954073]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned c=
ontrol mask: 0x1d
[    0.954081] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.959851] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    0.959939] pci 0000:ff:00.0: [8086:2c52] type 0 class 0x000600
[    0.959963] pci 0000:ff:00.1: [8086:2c81] type 0 class 0x000600
[    0.959986] pci 0000:ff:02.0: [8086:2c90] type 0 class 0x000600
[    0.960005] pci 0000:ff:02.1: [8086:2c91] type 0 class 0x000600
[    0.960027] pci 0000:ff:03.0: [8086:2c98] type 0 class 0x000600
[    0.960052] pci 0000:ff:03.1: [8086:2c99] type 0 class 0x000600
[    0.960073] pci 0000:ff:03.4: [8086:2c9c] type 0 class 0x000600
[    0.960094] pci 0000:ff:04.0: [8086:2ca0] type 0 class 0x000600
[    0.960113] pci 0000:ff:04.1: [8086:2ca1] type 0 class 0x000600
[    0.960132] pci 0000:ff:04.2: [8086:2ca2] type 0 class 0x000600
[    0.960152] pci 0000:ff:04.3: [8086:2ca3] type 0 class 0x000600
[    0.960173] pci 0000:ff:05.0: [8086:2ca8] type 0 class 0x000600
[    0.960193] pci 0000:ff:05.1: [8086:2ca9] type 0 class 0x000600
[    0.960214] pci 0000:ff:05.2: [8086:2caa] type 0 class 0x000600
[    0.960233] pci 0000:ff:05.3: [8086:2cab] type 0 class 0x000600
[    0.960266] pci_bus 0000:ff: on NUMA node 0
[    0.960275]  pci0000:ff: Requesting ACPI _OSC control (0x1d)
[    0.960282]  pci0000:ff: ACPI _OSC request failed (AE_NOT_FOUND), return=
ed control mask: 0x1d
[    0.960289] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.961086] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 =
15)
[    0.961155] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 *7 11 12 14 =
15)
[    0.961221] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.961290] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *10
[    0.961357] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.961420] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.961480] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *11
[    0.961540] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *10
[    0.961693] vgaarb: device added: PCI:0000:02:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.961708] vgaarb: loaded
[    0.961711] vgaarb: bridge control possible 0000:02:00.0
[    0.961829] SCSI subsystem initialized
[    0.961924] libata version 3.00 loaded.
[    0.962074] PCI: Using ACPI for IRQ routing
[    0.968804] PCI: pci_cache_line_size set to 64 bytes
[    0.969096] reserve RAM buffer: 000000000009c000 - 000000000009ffff=20
[    0.969099] reserve RAM buffer: 00000000bba7c000 - 00000000bbffffff=20
[    0.969103] reserve RAM buffer: 00000000bbbd7000 - 00000000bbffffff=20
[    0.969107] reserve RAM buffer: 00000000bbc5d000 - 00000000bbffffff=20
[    0.969111] reserve RAM buffer: 00000000bbf18000 - 00000000bbffffff=20
[    0.969114] reserve RAM buffer: 00000000bbf79000 - 00000000bbffffff=20
[    0.969116] reserve RAM buffer: 00000000bbfe2000 - 00000000bbffffff=20
[    0.969316] HPET: 8 timers in total, 5 timers will be used for per-cpu t=
imer
[    0.969333] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
[    0.969344] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.971961] hpet: hpet2 irq 40 for MSI
[    0.972110] hpet: hpet3 irq 41 for MSI
[    0.973119] hpet: hpet4 irq 42 for MSI
[    0.974128] hpet: hpet5 irq 43 for MSI
[    0.975114] hpet: hpet6 irq 44 for MSI
[    0.978069] Switching to clocksource hpet
[    0.978125] Switched to NOHz mode on CPU #4
[    0.978128] Switched to NOHz mode on CPU #6
[    0.978130] Switched to NOHz mode on CPU #2
[    0.978156] Switched to NOHz mode on CPU #3
[    0.979030] Switched to NOHz mode on CPU #7
[    0.979037] Switched to NOHz mode on CPU #5
[    0.979226] Switched to NOHz mode on CPU #1
[    0.979230] Switched to NOHz mode on CPU #0
[    0.985120] pnp: PnP ACPI init
[    0.985139] ACPI: bus type pnp registered
[    0.985585] pnp 00:00: [bus 00-fe]
[    0.985588] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.985591] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.985593] pnp 00:00: [io  0x0d00-0xffff window]
[    0.985596] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.985598] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.985600] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.985602] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.985605] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.985607] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.985609] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.985611] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.985614] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.985616] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.985618] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.985620] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.985623] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.985625] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.985627] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
[    0.985630] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.985632] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.985748] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.985808] pnp 00:01: [io  0x0000-0x001f]
[    0.985810] pnp 00:01: [io  0x0081-0x0091]
[    0.985812] pnp 00:01: [io  0x0093-0x009f]
[    0.985814] pnp 00:01: [io  0x00c0-0x00df]
[    0.985816] pnp 00:01: [dma 4]
[    0.985894] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.985905] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.985980] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.986083] pnp 00:03: [irq 0 disabled]
[    0.986092] pnp 00:03: [irq 8]
[    0.986094] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.986170] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.986183] pnp 00:04: [io  0x00f0]
[    0.986215] pnp 00:04: [irq 13]
[    0.986293] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.986307] pnp 00:05: [io  0x002e-0x002f]
[    0.986309] pnp 00:05: [io  0x004e-0x004f]
[    0.986311] pnp 00:05: [io  0x0061]
[    0.986313] pnp 00:05: [io  0x0063]
[    0.986314] pnp 00:05: [io  0x0065]
[    0.986318] pnp 00:05: [io  0x0067]
[    0.986320] pnp 00:05: [io  0x0068]
[    0.986321] pnp 00:05: [io  0x006c]
[    0.986323] pnp 00:05: [io  0x0070]
[    0.986325] pnp 00:05: [io  0x0080]
[    0.986327] pnp 00:05: [io  0x0092]
[    0.986328] pnp 00:05: [io  0x00b2-0x00b3]
[    0.986330] pnp 00:05: [io  0x0680-0x069f]
[    0.986332] pnp 00:05: [io  0x0500-0x050f]
[    0.986334] pnp 00:05: [io  0x0600-0x0603]
[    0.986336] pnp 00:05: [io  0xffff]
[    0.986338] pnp 00:05: [io  0x0400-0x047f]
[    0.986340] pnp 00:05: [io  0x1180-0x11ff]
[    0.986342] pnp 00:05: [io  0x164e-0x164f]
[    0.986344] pnp 00:05: [io  0xfe00]
[    0.986464] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.986472] system 00:05: [io  0x0500-0x050f] has been reserved
[    0.986478] system 00:05: [io  0x0600-0x0603] has been reserved
[    0.986484] system 00:05: [io  0xffff] has been reserved
[    0.986489] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.986495] system 00:05: [io  0x1180-0x11ff] has been reserved
[    0.986501] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.986507] system 00:05: [io  0xfe00] has been reserved
[    0.986514] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.986557] pnp 00:06: [io  0x0070-0x0077]
[    0.986637] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.986650] pnp 00:07: [io  0x0060]
[    0.986652] pnp 00:07: [io  0x0064]
[    0.986661] pnp 00:07: [irq 1]
[    0.986736] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.986753] pnp 00:08: [irq 12]
[    0.986827] pnp 00:08: Plug and Play ACPI device, IDs DLL046e PNP0f13 (a=
ctive)
[    0.987136] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    0.987138] pnp 00:09: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.987141] pnp 00:09: [mem 0xfed1b000-0xfed1bfff]
[    0.987143] pnp 00:09: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.987145] pnp 00:09: [mem 0xe0000000-0xefffffff]
[    0.987148] pnp 00:09: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.987150] pnp 00:09: [mem 0xc0000000-0xc0000fff]
[    0.987152] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
[    0.987154] pnp 00:09: [mem 0xfed90000-0xfed8ffff disabled]
[    0.987156] pnp 00:09: [mem 0xfed40000-0xfed44fff]
[    0.987158] pnp 00:09: [mem 0xfed45000-0xfed8ffff]
[    0.987160] pnp 00:09: [mem 0xff000000-0xffffffff]
[    0.987163] pnp 00:09: [mem 0xfee00000-0xfeefffff]
[    0.987310] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.987318] system 00:09: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    0.987324] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.987331] system 00:09: [mem 0xc0000000-0xc0000fff] has been reserved
[    0.987337] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.987344] system 00:09: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.987350] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.987357] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    0.987363] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.987371] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.987539] pnp 00:0a: [irq 20]
[    0.987631] pnp 00:0a: Plug and Play ACPI device, IDs SMO8800 (active)
[    0.989033] pnp 00:0b: [bus ff]
[    0.989133] pnp 00:0b: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.989148] pnp: PnP ACPI: found 12 devices
[    0.989153] ACPI: ACPI bus type pnp unregistered
[    0.998591] PCI: max bus depth: 1 pci_try_num: 2
[    0.998663] pci 0000:00:1c.5: BAR 14: assigned [mem 0xc0100000-0xc04ffff=
f]
[    0.998673] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0500000-0xc06ffff=
f 64bit pref]
[    0.998681] pci 0000:00:1c.1: BAR 13: assigned [io  0x6000-0x6fff]
[    0.998689] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0700000-0xc08ffff=
f]
[    0.998697] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0900000-0xc0affff=
f 64bit pref]
[    0.998705] pci 0000:00:1c.0: BAR 13: assigned [io  0x7000-0x7fff]
[    0.998713] pci 0000:02:00.0: BAR 6: assigned [mem 0xcd000000-0xcd07ffff=
 pref]
[    0.998721] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.998727] pci 0000:00:03.0:   bridge window [io  0x2000-0x2fff]
[    0.998734] pci 0000:00:03.0:   bridge window [mem 0xcc000000-0xcdefffff]
[    0.998742] pci 0000:00:03.0:   bridge window [mem 0xce000000-0xdfffffff=
 64bit pref]
[    0.998752] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.998762] pci 0000:00:1c.0:   bridge window [io  0x7000-0x7fff]
[    0.998775] pci 0000:00:1c.0:   bridge window [mem 0xc0700000-0xc08fffff]
[    0.998787] pci 0000:00:1c.0:   bridge window [mem 0xc0900000-0xc0afffff=
 64bit pref]
[    0.998803] pci 0000:00:1c.1: PCI bridge to [bus 04-04]
[    0.998813] pci 0000:00:1c.1:   bridge window [io  0x6000-0x6fff]
[    0.998826] pci 0000:00:1c.1:   bridge window [mem 0xf0500000-0xf05fffff]
[    0.998838] pci 0000:00:1c.1:   bridge window [mem 0xc0500000-0xc06fffff=
 64bit pref]
[    0.998854] pci 0000:00:1c.3: PCI bridge to [bus 05-06]
[    0.998864] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.998877] pci 0000:00:1c.3:   bridge window [mem 0xf0600000-0xf06fffff]
[    0.998890] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff=
 64bit pref]
[    0.998905] pci 0000:00:1c.4: PCI bridge to [bus 07-08]
[    0.998915] pci 0000:00:1c.4:   bridge window [io  0x4000-0x4fff]
[    0.998928] pci 0000:00:1c.4:   bridge window [mem 0xf0700000-0xf07fffff]
[    0.998940] pci 0000:00:1c.4:   bridge window [mem 0xf0200000-0xf03fffff=
 64bit pref]
[    0.998956] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.998966] pci 0000:00:1c.5:   bridge window [io  0x5000-0x5fff]
[    0.998979] pci 0000:00:1c.5:   bridge window [mem 0xc0100000-0xc04fffff]
[    0.998992] pci 0000:00:1c.5:   bridge window [mem 0xf0400000-0xf04fffff=
 64bit pref]
[    0.999007] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
[    0.999012] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.999024] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.999035] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.999058] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.999066] pci 0000:00:03.0: setting latency timer to 64
[    0.999083] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.999095] pci 0000:00:1c.0: setting latency timer to 64
[    0.999112] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.999125] pci 0000:00:1c.1: setting latency timer to 64
[    0.999142] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.999155] pci 0000:00:1c.3: setting latency timer to 64
[    0.999170] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.999182] pci 0000:00:1c.4: setting latency timer to 64
[    0.999209] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.999221] pci 0000:00:1c.5: setting latency timer to 64
[    0.999237] pci 0000:00:1e.0: setting latency timer to 64
[    0.999246] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.999248] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.999251] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.999253] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.999255] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.999258] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.999260] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.999263] pci_bus 0000:00: resource 11 [mem 0xc0000000-0xdfffffff]
[    0.999265] pci_bus 0000:00: resource 12 [mem 0xf0000000-0xfebfffff]
[    0.999268] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.999270] pci_bus 0000:02: resource 1 [mem 0xcc000000-0xcdefffff]
[    0.999273] pci_bus 0000:02: resource 2 [mem 0xce000000-0xdfffffff 64bit=
 pref]
[    0.999275] pci_bus 0000:03: resource 0 [io  0x7000-0x7fff]
[    0.999278] pci_bus 0000:03: resource 1 [mem 0xc0700000-0xc08fffff]
[    0.999280] pci_bus 0000:03: resource 2 [mem 0xc0900000-0xc0afffff 64bit=
 pref]
[    0.999283] pci_bus 0000:04: resource 0 [io  0x6000-0x6fff]
[    0.999285] pci_bus 0000:04: resource 1 [mem 0xf0500000-0xf05fffff]
[    0.999288] pci_bus 0000:04: resource 2 [mem 0xc0500000-0xc06fffff 64bit=
 pref]
[    0.999291] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
[    0.999293] pci_bus 0000:05: resource 1 [mem 0xf0600000-0xf06fffff]
[    0.999295] pci_bus 0000:05: resource 2 [mem 0xf0000000-0xf01fffff 64bit=
 pref]
[    0.999298] pci_bus 0000:07: resource 0 [io  0x4000-0x4fff]
[    0.999300] pci_bus 0000:07: resource 1 [mem 0xf0700000-0xf07fffff]
[    0.999303] pci_bus 0000:07: resource 2 [mem 0xf0200000-0xf03fffff 64bit=
 pref]
[    0.999305] pci_bus 0000:09: resource 0 [io  0x5000-0x5fff]
[    0.999308] pci_bus 0000:09: resource 1 [mem 0xc0100000-0xc04fffff]
[    0.999310] pci_bus 0000:09: resource 2 [mem 0xf0400000-0xf04fffff 64bit=
 pref]
[    0.999313] pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7]
[    0.999315] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
[    0.999318] pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff]
[    0.999320] pci_bus 0000:0a: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.999323] pci_bus 0000:0a: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.999325] pci_bus 0000:0a: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.999327] pci_bus 0000:0a: resource 10 [mem 0x000dc000-0x000dffff]
[    0.999330] pci_bus 0000:0a: resource 11 [mem 0xc0000000-0xdfffffff]
[    0.999332] pci_bus 0000:0a: resource 12 [mem 0xf0000000-0xfebfffff]
[    0.999381] NET: Registered protocol family 2
[    0.999457] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.999747] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    1.001389] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.001794] TCP: Hash tables configured (established 262144 bind 65536)
[    1.001800] TCP reno registered
[    1.001805] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.001848] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.002027] NET: Registered protocol family 1
[    1.002220] pci 0000:02:00.0: Boot video device
[    1.002367] PCI: CLS 64 bytes, default 64
[    1.002403] Unpacking initramfs...
[    1.319221] Freeing initrd memory: 1100k freed
[    1.319392] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.319399] Placing 64MB software IO TLB between ffff8800b7a7c000 - ffff=
8800bba7c000
[    1.319406] software IO TLB at phys 0xb7a7c000 - 0xbba7c000
[    1.319433] Simple Boot Flag at 0x36 set to 0x1
[    1.323336] microcode: CPU0 sig=3D0x106e5, pf=3D0x10, revision=3D0x3
[    1.323351] microcode: CPU1 sig=3D0x106e5, pf=3D0x10, revision=3D0x3
[    1.323366] microcode: CPU2 sig=3D0x106e5, pf=3D0x10, revision=3D0x3
[    1.323375] microcode: CPU3 sig=3D0x106e5, pf=3D0x10, revision=3D0x3
[    1.323391] microcode: CPU4 sig=3D0x106e5, pf=3D0x10, revision=3D0x3
[    1.323405] microcode: CPU5 sig=3D0x106e5, pf=3D0x10, revision=3D0x3
[    1.323418] microcode: CPU6 sig=3D0x106e5, pf=3D0x10, revision=3D0x3
[    1.323433] microcode: CPU7 sig=3D0x106e5, pf=3D0x10, revision=3D0x3
[    1.323509] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    1.323959] audit: initializing netlink socket (disabled)
[    1.323972] type=3D2000 audit(1309045484.119:1): initialized
[    1.348127] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.365897] fuse init (API version 7.16)
[    1.366151] SGI XFS with security attributes, large block/inode numbers,=
 no debug enabled
[    1.367793] Btrfs loaded
[    1.367802] msgmni has been set to 7775
[    1.369354] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    1.369363] io scheduler noop registered
[    1.369470] io scheduler cfq registered (default)
[    1.370428] vesafb: mode is 1024x768x8, linelength=3D1024, pages=3D3
[    1.370434] vesafb: scrolling: redraw
[    1.370439] vesafb: Pseudocolor: size=3D8:8:8:8, shift=3D0:0:0:0
[    1.370932] vesafb: framebuffer at 0xcf000000, mapped to 0xffffc90010100=
000, using 1536k, total 14336k
[    1.401908] Console: switching to colour frame buffer device 128x48
[    1.436749] fb0: VESA VGA frame buffer device
[    1.437061] intel_idle: MWAIT substates: 0x1120
[    1.437077] intel_idle: v0.4 model 0x1E
[    1.437079] intel_idle: lapic_timer_reliable_states 0x2
[    1.637092] ACPI: AC Adapter [ADP1] (on-line)
[    1.637488] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input0
[    1.637969] ACPI: Power Button [PWRB]
[    1.638260] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input1
[    1.638723] ACPI: Sleep Button [SLPB]
[    1.639029] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input2
[    1.640354] ACPI: Lid Switch [LID0]
[    1.640639] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input3
[    1.641074] ACPI: Power Button [PWRF]
[    1.641433] ACPI: Fan [FAN0] (off)
[    1.641702] ACPI: Fan [FAN1] (off)
[    1.642006] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
[    1.648333] acpi device:02: registered as cooling_device2
[    1.648730] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/device:01/LNXVIDEO:00/input/input4
[    1.649304] ACPI: Video Device [PEGP] (multi-head: yes  rom: no  post: n=
o)
[    1.649752] ACPI: acpi_idle yielding to intel_idle
[    1.652892] thermal LNXTHERM:00: registered as thermal_zone0
[    1.653236] ACPI: Thermal Zone [TZ00] (27 C)
[    1.664815] thermal LNXTHERM:01: registered as thermal_zone1
[    1.676397] ACPI: Thermal Zone [TZ01] (0 C)
[    1.688415] ERST: Table is not found!
[    1.700259] GHES: HEST is not enabled!
[    1.716120] loop: module loaded
[    1.720940] ACPI: Battery Slot [BAT0] (battery present)
[    1.740747] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.752512] r8169 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ =
17
[    1.764425] r8169 0000:09:00.0: setting latency timer to 64
[    1.764486] r8169 0000:09:00.0: irq 45 for MSI/MSI-X
[    1.764832] r8169 0000:09:00.0: eth0: RTL8168e/8111e at 0xffffc9000001e0=
00, f0:4d:a2:57:63:6f, XID 0c200000 IRQ 45
[    1.777252] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0=
x60,0x64 irq 1,12
[    1.795189] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.807340] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.819406] mousedev: PS/2 mouse device common for all mice
[    1.831827] rtc_cmos 00:06: RTC can wake from S4
[    1.844113] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.856191] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.868335] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) ->=
 IRQ 18
[    1.870236] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input5
[    1.896982] cpuidle: using governor ladder
[    1.912706] cpuidle: using governor menu
[    1.925207] Netfilter messages via NETLINK v0.30.
[    1.937534] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.950246] ctnetlink v0.93: registering with nfnetlink.
[    1.962516] ip_set: protocol 6
[    1.975174] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.989230] TCP cubic registered
[    2.003169] TCP htcp registered
[    2.016797] NET: Registered protocol family 17
[    2.030738] registered taskstats version 1
[    2.053337] rtc_cmos 00:06: setting system clock to 2011-06-25 23:44:45 =
UTC (1309045485)
[    2.071451] Freeing unused kernel memory: 652k freed
[    2.082531] Write protecting the kernel read-only data: 10240k
[    2.095063] Freeing unused kernel memory: 448k freed
[    2.110758] Freeing unused kernel memory: 1900k freed
[    2.320728] Refined TSC clocksource calibration: 1729.000 MHz.
[    2.331527] Switching to clocksource tsc
[    2.454550] ahci 0000:00:1f.2: version 3.0
[    2.454591] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.466504] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[    2.466551] ahci: SSS flag set, parallel bus scan disabled
[    2.478441] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x=
13 impl SATA mode
[    2.490827] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led cl=
o pio slum part ems sxs apst=20
[    2.503227] ahci 0000:00:1f.2: setting latency timer to 64
[    2.509625] scsi0 : ahci
[    2.521657] scsi1 : ahci
[    2.533437] scsi2 : ahci
[    2.544964] scsi3 : ahci
[    2.556192] scsi4 : ahci
[    2.566968] scsi5 : ahci
[    2.577350] ata1: SATA max UDMA/133 abar m2048@0xf0a06000 port 0xf0a0610=
0 irq 46
[    2.587875] ata2: SATA max UDMA/133 abar m2048@0xf0a06000 port 0xf0a0618=
0 irq 46
[    2.598145] ata3: DUMMY
[    2.608192] ata4: DUMMY
[    2.618100] ata5: SATA max UDMA/133 abar m2048@0xf0a06000 port 0xf0a0630=
0 irq 46
[    2.628264] ata6: DUMMY
[    2.942509] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.958524] ata1.00: ATA-8: SAMSUNG HM640JJ, 2AK10001, max UDMA/133
[    2.968280] ata1.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    2.984287] ata1.00: configured for UDMA/133
[    2.994325] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM640JJ  2A=
K1 PQ: 0 ANSI: 5
[    3.004864] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    3.320331] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.341581] ata2.00: ATAPI: HL-DT-ST DVDRW/BDROM CT30N, A101, max UDMA/1=
33
[    3.355381] ata2.00: configured for UDMA/133
[    3.368813] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRWBD CT30N    A1=
01 PQ: 0 ANSI: 5
[    3.383323] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    3.394039] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.405015] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.405136] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.721170] ata5: SATA link down (SStatus 0 SControl 300)
[    3.735584] sd 0:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 G=
B/596 GiB)
[    3.746559] sd 0:0:0:0: [sda] Write Protect is off
[    3.757370] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.757405] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.923906]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 s=
da11 sda12 sda13 >
[    3.936024] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.000752] EXT4-fs (sda6): INFO: recovery required on readonly filesyst=
em
[    5.011580] EXT4-fs (sda6): write access will be enabled during recovery
[    5.105840] EXT4-fs (sda6): orphan cleanup on readonly fs
[    5.116412] EXT4-fs (sda6): ext4_orphan_cleanup: deleting unreferenced i=
node 2883637
[    5.116447] EXT4-fs (sda6): 1 orphan inode deleted
[    5.126768] EXT4-fs (sda6): recovery complete
[    5.685790] EXT4-fs (sda6): mounted filesystem with ordered data mode. O=
pts: (null)
[    5.879364] CE: hpet increased min_delta_ns to 20113 nsec
[    7.787467] udevd[1572]: starting version 171
[    8.195451] Linux agpgart interface v0.103
[    8.266565] usbcore: registered new interface driver usbfs
[    8.266607] usbcore: registered new interface driver hub
[    8.266767] usbcore: registered new device driver usb
[    8.299092] wmi: 8D9DDCBC-A997-11DA-B012-B622A1EF5492:
[    8.299095] wmi: 	object_id: AA
[    8.299098] wmi: 	notify_id: 41
[    8.299100] wmi: 	reserved: 41
[    8.299102] wmi: 	instance_count: 1
[    8.299104] wmi: 	flags: 0x0
[    8.299184] wmi: ABBC0F6C-8EA1-11D1-00A0-C90629100000:
[    8.299187] wmi: 	object_id: AB
[    8.299189] wmi: 	notify_id: 41
[    8.299191] wmi: 	reserved: 42
[    8.299193] wmi: 	instance_count: 1
[    8.299195] wmi: 	flags: 0x0
[    8.299250] wmi: A80593CE-A997-11DA-B012-B622A1EF5492:
[    8.299253] wmi: 	object_id: BA
[    8.299255] wmi: 	notify_id: 42
[    8.299256] wmi: 	reserved: 41
[    8.299258] wmi: 	instance_count: 1
[    8.299260] wmi: 	flags: 0x2 ACPI_WMI_METHOD
[    8.299315] wmi: ABBC0F6D-8EA1-11D1-00A0-C90629100000:
[    8.299317] wmi: 	object_id: BB
[    8.299319] wmi: 	notify_id: 42
[    8.299321] wmi: 	reserved: 42
[    8.299323] wmi: 	instance_count: 1
[    8.299325] wmi: 	flags: 0x2 ACPI_WMI_METHOD
[    8.299401] wmi: DD8C7670-1CB5-11DB-A98B-0800200C9A66:
[    8.299404] wmi: 	object_id: BC
[    8.299406] wmi: 	notify_id: 42
[    8.299407] wmi: 	reserved: 43
[    8.299409] wmi: 	instance_count: 1
[    8.299411] wmi: 	flags: 0x2 ACPI_WMI_METHOD
[    8.299469] wmi: 9DBB5994-A997-11DA-B012-B622A1EF5492:
[    8.299472] wmi: 	object_id: =D0
[    8.299474] wmi: 	notify_id: D0
[    8.299476] wmi: 	reserved: 00
[    8.299477] wmi: 	instance_count: 1
[    8.299480] wmi: 	flags: 0x8 ACPI_WMI_EVENT
[    8.299563] wmi: A3776CE0-1E88-11DB-A98B-0800200C9A66:
[    8.299566] wmi: 	object_id: BC
[    8.299568] wmi: 	notify_id: 42
[    8.299570] wmi: 	reserved: 43
[    8.299572] wmi: 	instance_count: 1
[    8.299574] wmi: 	flags: 0x0
[    8.299635] wmi: 05901221-D566-11D1-B2F0-00A0C9062910:
[    8.299638] wmi: 	object_id: MO
[    8.299640] wmi: 	notify_id: 4D
[    8.299642] wmi: 	reserved: 4F
[    8.299644] wmi: 	instance_count: 1
[    8.299645] wmi: 	flags: 0x0
[    8.299753] wmi: Mapper loaded
[    8.342793] iTCO_vendor_support: vendor-support=3D0
[    8.370167] xhci_hcd 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> I=
RQ 19
[    8.370200] xhci_hcd 0000:05:00.0: setting latency timer to 64
[    8.370208] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    8.370227] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 1
[    8.370748] xhci_hcd 0000:05:00.0: irq 19, io mem 0xf0600000
[    8.370962] xhci_hcd 0000:05:00.0: irq 47 for MSI/MSI-X
[    8.370966] xhci_hcd 0000:05:00.0: irq 48 for MSI/MSI-X
[    8.370969] xhci_hcd 0000:05:00.0: irq 49 for MSI/MSI-X
[    8.370973] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[    8.370976] xhci_hcd 0000:05:00.0: irq 51 for MSI/MSI-X
[    8.370980] xhci_hcd 0000:05:00.0: irq 52 for MSI/MSI-X
[    8.370983] xhci_hcd 0000:05:00.0: irq 53 for MSI/MSI-X
[    8.370987] xhci_hcd 0000:05:00.0: irq 54 for MSI/MSI-X
[    8.371307] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    8.371309] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    8.371312] usb usb1: Product: xHCI Host Controller
[    8.371314] usb usb1: Manufacturer: Linux 3.0.0-rc4-LYM xhci_hcd
[    8.371316] usb usb1: SerialNumber: 0000:05:00.0
[    8.371414] xHCI xhci_add_endpoint called for root hub
[    8.371418] xHCI xhci_check_bandwidth called for root hub
[    8.371474] hub 1-0:1.0: USB hub found
[    8.371495] hub 1-0:1.0: 2 ports detected
[    8.371591] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    8.371597] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 2
[    8.373853] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[    8.373856] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    8.373859] usb usb2: Product: xHCI Host Controller
[    8.373861] usb usb2: Manufacturer: Linux 3.0.0-rc4-LYM xhci_hcd
[    8.373863] usb usb2: SerialNumber: 0000:05:00.0
[    8.374005] xHCI xhci_add_endpoint called for root hub
[    8.374008] xHCI xhci_check_bandwidth called for root hub
[    8.374062] hub 2-0:1.0: USB hub found
[    8.374105] hub 2-0:1.0: 2 ports detected
[    8.508198] intel ips 0000:00:1f.6: Non-IPS CPU detected.
[    8.508202] intel ips 0000:00:1f.6: IPS not supported on this CPU
[    8.531775] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    8.533755] EDAC MC: Ver: 2.1.0
[    8.536726] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0':=
 DEV 0000:ff:03.0
[    8.536852] EDAC PCI0: Giving out device to module 'i7core_edac' control=
ler 'EDAC PCI controller': DEV '0000:ff:03.0' (POLLED)
[    8.536856] EDAC i7core: Driver loaded.
[    8.568122] mei: module is from the staging directory, the quality is un=
known, you have been warned.
[    8.568696] mei 0000:00:16.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.568707] mei 0000:00:16.0: setting latency timer to 64
[    8.654715] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    8.655790] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    8.656003] iTCO_wdt: Found a HM57 TCO device (Version=3D2, TCOBASE=3D0x=
0460)
[    8.656152] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[    8.673994] usb 1-2: new low speed USB device number 2 using xhci_hcd
[    8.698205] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.698240] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    8.698264] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    8.698272] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    8.698283] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[    8.698322] ehci_hcd 0000:00:1a.0: debug port 2
[    8.702306] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    8.702323] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf0a07000
[    8.709802] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[    8.712953] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    8.712987] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    8.712993] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    8.712996] usb usb3: Product: EHCI Host Controller
[    8.712999] usb usb3: Manufacturer: Linux 3.0.0-rc4-LYM ehci_hcd
[    8.713002] usb usb3: SerialNumber: 0000:00:1a.0
[    8.713305] hub 3-0:1.0: USB hub found
[    8.713309] hub 3-0:1.0: 3 ports detected
[    8.713400] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    8.713478] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    8.713486] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    8.713493] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 4
[    8.713527] ehci_hcd 0000:00:1d.0: debug port 2
[    8.717497] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    8.717529] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf0a07400
[    8.721788] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[    8.725795] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[    8.726783] usb 1-2: New USB device found, idVendor=3D045e, idProduct=3D=
0734
[    8.726791] usb 1-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    8.726793] usb 1-2: Product: Microsoft=C2=AE Wireless Receiver 700 v2.0
[    8.726794] usb 1-2: Manufacturer: Liteon
[    8.727011] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    8.727031] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    8.727034] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    8.727037] usb usb4: Product: EHCI Host Controller
[    8.727039] usb usb4: Manufacturer: Linux 3.0.0-rc4-LYM ehci_hcd
[    8.727041] usb usb4: SerialNumber: 0000:00:1d.0
[    8.727045] usb 1-2: ep 0x81 - rounding interval to 64 microframes, ep d=
esc says 80 microframes
[    8.727053] usb 1-2: ep 0x82 - rounding interval to 64 microframes, ep d=
esc says 80 microframes
[    8.727269] hub 4-0:1.0: USB hub found
[    8.727276] hub 4-0:1.0: 3 ports detected
[    9.021347] usb 3-1: new high speed USB device number 2 using ehci_hcd
[    9.058308] cfg80211: Calling CRDA to update world regulatory domain
[    9.135274] usb 3-1: New USB device found, idVendor=3D8087, idProduct=3D=
0020
[    9.135277] usb 3-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    9.135709] hub 3-1:1.0: USB hub found
[    9.135782] hub 3-1:1.0: 6 ports detected
[    9.137029] nvidia: module license 'NVIDIA' taints kernel.
[    9.137031] Disabling lock debugging due to kernel taint
[    9.238722] usb 4-1: new high speed USB device number 2 using ehci_hcd
[    9.354060] usb 4-1: New USB device found, idVendor=3D8087, idProduct=3D=
0020
[    9.354064] usb 4-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    9.354781] hub 4-1:1.0: USB hub found
[    9.354928] hub 4-1:1.0: 8 ports detected
[    9.408091] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0x=
d04773/0xa40000/0x8a0400
[    9.418927] usb 3-1.4: new high speed USB device number 3 using ehci_hcd
[    9.458872] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input7
[    9.501228] nvidia 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ=
 16
[    9.501236] nvidia 0000:02:00.0: setting latency timer to 64
[    9.501241] vgaarb: device changed decodes: PCI:0000:02:00.0,olddecodes=
=3Dio+mem,decodes=3Dnone:owns=3Dio+mem
[    9.501487] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  275.09.07  W=
ed Jun  8 14:16:46 PDT 2011
[    9.505698] usb 3-1.4: New USB device found, idVendor=3D0408, idProduct=
=3D2fb1
[    9.505706] usb 3-1.4: New USB device strings: Mfr=3D3, Product=3D2, Ser=
ialNumber=3D0
[    9.505712] usb 3-1.4: Product: Laptop_Integrated_Webcam_2HDM
[    9.505716] usb 3-1.4: Manufacturer: CN07CN2C7866409H02C3A00
[    9.601918] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> =
IRQ 22
[    9.601980] HDA Intel 0000:00:1b.0: irq 55 for MSI/MSI-X
[    9.602019] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.629882] usb 4-1.3: new low speed USB device number 3 using ehci_hcd
[    9.646179] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in=
-tree:
[    9.646182] iwlagn: Copyright(c) 2003-2011 Intel Corporation
[    9.646273] iwlagn 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[    9.646319] iwlagn 0000:04:00.0: setting latency timer to 64
[    9.646398] iwlagn 0000:04:00.0: Detected Intel(R) Centrino(R) Advanced-=
N 6200 AGN, REV=3D0x74
[    9.678960] iwlagn 0000:04:00.0: device EEPROM VER=3D0x43a, CALIB=3D0x6
[    9.678962] iwlagn 0000:04:00.0: Device SKU: 0Xb
[    9.678971] iwlagn 0000:04:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[    9.679464] iwlagn 0000:04:00.0: irq 56 for MSI/MSI-X
[    9.722412] usb 4-1.3: New USB device found, idVendor=3D093a, idProduct=
=3D2500
[    9.722420] usb 4-1.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    9.722426] usb 4-1.3: Product: USB OPTICAL MOUSE
[    9.722430] usb 4-1.3: Manufacturer: PIXART
[    9.819914] iwlagn 0000:04:00.0: loaded firmware version 9.221.4.1 build=
 25532
[    9.820237] Registered led device: phy0-led
[    9.820430] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    9.849998] hda_codec: ALC665: SKU not ready 0x598301f0
[    9.850174] hda_codec: ALC665: BIOS auto-probing.
[    9.854109] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sou=
nd/card0/input8
[    9.854226] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b=
=2E0/sound/card0/input9
[    9.854365] HDA Intel 0000:02:00.1: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[    9.854423] HDA Intel 0000:02:00.1: irq 57 for MSI/MSI-X
[    9.854446] HDA Intel 0000:02:00.1: setting latency timer to 64
[   10.224318] HDMI status: Pin=3D5 Presence_Detect=3D0 ELD_Valid=3D0
[   10.260409] HDMI status: Pin=3D5 Presence_Detect=3D0 ELD_Valid=3D0
[   10.294357] HDMI status: Pin=3D5 Presence_Detect=3D0 ELD_Valid=3D0
[   10.327331] HDMI status: Pin=3D5 Presence_Detect=3D0 ELD_Valid=3D0
[   10.377179] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.=
0/0000:02:00.1/sound/card1/input10
[   10.377327] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.=
0/0000:02:00.1/sound/card1/input11
[   10.377436] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.=
0/0000:02:00.1/sound/card1/input12
[   10.377540] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.=
0/0000:02:00.1/sound/card1/input13
[   10.583391] input: Liteon Microsoft=C2=AE Wireless Receiver 700 v2.0 as =
/devices/pci0000:00/0000:00:1c.3/0000:05:00.0/usb1/1-2/1-2:1.0/input/input14
[   10.583696] generic-usb 0003:045E:0734.0001: input,hidraw0: USB HID v1.1=
1 Keyboard [Liteon Microsoft=C2=AE Wireless Receiver 700 v2.0] on usb-0000:=
05:00.0-2/input0
[   10.609416] input: Liteon Microsoft=C2=AE Wireless Receiver 700 v2.0 as =
/devices/pci0000:00/0000:00:1c.3/0000:05:00.0/usb1/1-2/1-2:1.1/input/input15
[   10.609748] generic-usb 0003:045E:0734.0002: input,hidraw1: USB HID v1.1=
1 Mouse [Liteon Microsoft=C2=AE Wireless Receiver 700 v2.0] on usb-0000:05:=
00.0-2/input1
[   10.613697] input: PIXART USB OPTICAL MOUSE as /devices/pci0000:00/0000:=
00:1d.0/usb4/4-1/4-1.3/4-1.3:1.0/input/input16
[   10.614015] generic-usb 0003:093A:2500.0003: input,hidraw2: USB HID v1.1=
0 Mouse [PIXART USB OPTICAL MOUSE] on usb-0000:00:1d.0-1.3/input0
[   10.614072] usbcore: registered new interface driver usbhid
[   10.614075] usbhid: USB HID core driver
[   17.559408] EXT4-fs (sda6): re-mounted. Opts: barrier=3D0,commit=3D60,us=
er_xattr
[   17.660421] EXT4-fs (sda7): barriers disabled
[   17.673673] EXT4-fs (sda7): mounted filesystem with ordered data mode. O=
pts: barrier=3D0,commit=3D120,journal_async_commit
[   17.683714] EXT4-fs (sda8): barriers disabled
[   17.698310] EXT4-fs (sda8): mounted filesystem with ordered data mode. O=
pts: barrier=3D0,commit=3D120,user_xattr,journal_async_commit
[   17.750738] XFS (sda9): Mounting Filesystem
[   17.896850] XFS (sda9): Ending clean mount
[   17.933735] XFS (sda12): Mounting Filesystem
[   18.095765] XFS (sda12): Ending clean mount
[   18.199488] XFS (sda13): Mounting Filesystem
[   18.334376] XFS (sda13): Ending clean mount
[   18.358727] XFS (sda10): Mounting Filesystem
[   18.462931] XFS (sda10): Starting recovery (logdev: internal)
[   18.514042] XFS (sda10): Ending recovery (logdev: internal)
[   18.568923] EXT4-fs (sda11): barriers disabled
[   18.583412] EXT4-fs (sda11): mounted filesystem with ordered data mode. =
Opts: barrier=3D0,commit=3D120,journal_async_commit
[   20.968925] r8169 0000:09:00.0: eth0: link down
[   20.968936] r8169 0000:09:00.0: eth0: link down
[   21.102537] coretemp coretemp.0: TjMax is 100 C.
[   21.102547] coretemp coretemp.0: TjMax is 100 C.
[   21.102558] coretemp coretemp.0: TjMax is 100 C.
[   21.102569] coretemp coretemp.0: TjMax is 100 C.
[   22.579571] r8169 0000:09:00.0: eth0: link up
[   41.051002] u32 classifier
[   41.051007]     Performance counters on
[   41.051010]     Actions configured
[   54.045951] nvidia 0000:02:00.0: irq 58 for MSI/MSI-X
[  786.865219] usb 1-1: new high speed USB device number 3 using xhci_hcd
[  786.877951] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  786.878319] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  786.878691] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  786.879185] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  786.879334] usb 1-1: New USB device found, idVendor=3D1058, idProduct=3D=
1100
[  786.879336] usb 1-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[  786.879339] usb 1-1: Product: My Book        =20
[  786.879341] usb 1-1: Manufacturer: Western Digital=20
[  786.879343] usb 1-1: SerialNumber: 57442D574341554632353938333138
[  786.987465] Initializing USB Mass Storage driver...
[  786.987868] scsi6 : usb-storage 1-1:1.0
[  786.988325] usbcore: registered new interface driver usb-storage
[  786.988331] USB Mass Storage support registered.
[  787.988935] scsi 6:0:0:0: Direct-Access     WD       6400AAV External 1.=
75 PQ: 0 ANSI: 4
[  788.117750] sd 6:0:0:0: [sdb] 1250263728 512-byte logical blocks: (640 G=
B/596 GiB)
[  788.117830] sd 6:0:0:0: Attached scsi generic sg2 type 0
[  788.118027] sd 6:0:0:0: [sdb] Write Protect is off
[  788.118034] sd 6:0:0:0: [sdb] Mode Sense: 23 00 00 00
[  788.118270] sd 6:0:0:0: [sdb] No Caching mode page present
[  788.118278] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  788.119764] sd 6:0:0:0: [sdb] No Caching mode page present
[  788.119771] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  788.197274]  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 >
[  788.199804] sd 6:0:0:0: [sdb] No Caching mode page present
[  788.199810] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  788.199816] sd 6:0:0:0: [sdb] Attached SCSI disk
[  793.015049] EXT4-fs (sdb1): warning: maximal mount count reached, runnin=
g e2fsck is recommended
[  793.015871] EXT4-fs (sdb1): mounted filesystem with ordered data mode. O=
pts: commit=3D60
[  793.094410] EXT4-fs (sdb2): warning: maximal mount count reached, runnin=
g e2fsck is recommended
[  793.095151] EXT4-fs (sdb2): mounted filesystem with ordered data mode. O=
pts: commit=3D60
[  793.166123] EXT4-fs (sdb5): warning: maximal mount count reached, runnin=
g e2fsck is recommended
[  793.166834] EXT4-fs (sdb5): mounted filesystem with ordered data mode. O=
pts: commit=3D60
[  793.248298] EXT4-fs (sdb6): warning: maximal mount count reached, runnin=
g e2fsck is recommended
[  793.249021] EXT4-fs (sdb6): mounted filesystem with ordered data mode. O=
pts: commit=3D60
[  793.306100] XFS (sdb7): Mounting Filesystem
[  793.591486] XFS (sdb7): Ending clean mount
[  793.614584] XFS (sdb8): Mounting Filesystem
[  793.906926] XFS (sdb8): Ending clean mount
[ 1041.240461] hrtimer: interrupt took 13151 ns
[ 1254.285524] nbd: registered device at major 43
[ 1967.356694] Linux media interface: v0.10
[ 1985.707620] Linux video capture interface: v2.00
[ 1985.732475] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_2HD=
M (0408:2fb1)
[ 1985.759844] uvcvideo: No streaming interface found for terminal 6.
[ 1985.759863] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000050
[ 1985.759871] IP: [<ffffffffa0da23e0>] media_entity_init+0x40/0xa0 [media]
[ 1985.759884] PGD 10f9eb067 PUD 1397ce067 PMD 0=20
[ 1985.759892] Oops: 0002 [#1] PREEMPT SMP=20
[ 1985.759899] CPU 0=20
[ 1985.759901] Modules linked in: uvcvideo(+) videodev v4l2_compat_ioctl32 =
media nbd kvm_intel kvm usb_storage cls_u32 sch_sfb sch_htb max6650 coretem=
p usbhid snd_hda_codec_hdmi snd_hda_codec_realtek iwlagn snd_hda_intel mac8=
0211 snd_hda_codec nvidia(P) snd_pcm cfg80211 dell_laptop rfkill ehci_hcd s=
nd_timer iTCO_wdt dell_wmi snd soundcore snd_page_alloc psmouse sparse_keym=
ap mei(C) i7core_edac edac_core dcdbas intel_ips xhci_hcd iTCO_vendor_suppo=
rt wmi usbcore agpgart sd_mod ahci libahci
[ 1985.759961]=20
[ 1985.759967] Pid: 14596, comm: modprobe Tainted: P         C  3.0.0-rc4-L=
YM #8 Dell Inc. XPS L501X  /0J1VR3
[ 1985.759975] RIP: 0010:[<ffffffffa0da23e0>]  [<ffffffffa0da23e0>] media_e=
ntity_init+0x40/0xa0 [media]
[ 1985.759986] RSP: 0018:ffff88013a657bc8  EFLAGS: 00010282
[ 1985.759990] RAX: ffff880126cfd6e0 RBX: 0000000000000000 RCX: 00000000000=
00000
[ 1985.759995] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880126c=
fd700
[ 1985.760000] RBP: ffff88013a657bf8 R08: 0000000000000000 R09: ffff880126c=
fd6e0
[ 1985.760004] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000=
00001
[ 1985.760008] R13: ffff8800b18c7d58 R14: 0000000000000001 R15: 00000000000=
00001
[ 1985.760014] FS:  00007f7cb0722700(0000) GS:ffff88013fc00000(0000) knlGS:=
0000000000000000
[ 1985.760019] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1985.760024] CR2: 0000000000000050 CR3: 0000000132f04000 CR4: 00000000000=
006f0
[ 1985.760029] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 1985.760034] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 1985.760039] Process modprobe (pid: 14596, threadinfo ffff88013a656000, t=
ask ffff88013940c920)
[ 1985.760043] Stack:
[ 1985.760046]  ffff8800b76fac00 ffff8800b18c7800 ffff8800b18c7070 ffff8800=
b7679d80
[ 1985.760055]  ffff8800b7679d98 0000000000000000 ffff88013a657c38 ffffffff=
a0df211a
[ 1985.760063]  ffff88013a657c38 ffff8800b7679d88 ffff8800b18c0cc0 ffff8800=
b18c0800
[ 1985.760072] Call Trace:
[ 1985.760086]  [<ffffffffa0df211a>] uvc_mc_register_entities+0xba/0x25c [u=
vcvideo]
[ 1985.760100]  [<ffffffffa0de8a48>] uvc_probe+0x388/0x2550 [uvcvideo]
[ 1985.760128]  [<ffffffffa0047ed3>] usb_probe_interface+0xf3/0x250 [usbcor=
e]
[ 1985.760138]  [<ffffffff81425bfc>] driver_probe_device+0x9c/0x2b0
[ 1985.760144]  [<ffffffff81425ebb>] __driver_attach+0xab/0xb0
[ 1985.760151]  [<ffffffff81425e10>] ? driver_probe_device+0x2b0/0x2b0
[ 1985.760157]  [<ffffffff81425e10>] ? driver_probe_device+0x2b0/0x2b0
[ 1985.760165]  [<ffffffff81424a0c>] bus_for_each_dev+0x5c/0x90
[ 1985.760173]  [<ffffffff8142580e>] driver_attach+0x1e/0x20
[ 1985.760179]  [<ffffffff81425410>] bus_add_driver+0x1b0/0x2a0
[ 1985.760186]  [<ffffffff814263f6>] driver_register+0x76/0x140
[ 1985.760205]  [<ffffffffa0046cbd>] usb_register_driver+0x9d/0x190 [usbcor=
e]
[ 1985.760213]  [<ffffffffa0dba000>] ? 0xffffffffa0db9fff
[ 1985.760224]  [<ffffffffa0dba020>] uvc_init+0x20/0x1000 [uvcvideo]
[ 1985.760234]  [<ffffffff810001d0>] do_one_initcall+0x40/0x170
[ 1985.760243]  [<ffffffff8108494e>] sys_init_module+0xbe/0x230
[ 1985.760252]  [<ffffffff815881eb>] system_call_fastpath+0x16/0x1b
[ 1985.760256] Code: 90 44 0f b7 f6 44 0f b7 f9 48 89 fb 45 01 f7 41 89 f4 =
be d0 80 00 00 44 89 ff 49 89 d5 48 c1 e7 05 e8 35 60 38 e0 48 85 c0 74 56=
=20
[ 1985.760296]  89 43 50 31 c0 45 85 f6 c7 43 38 00 00 00 00 66 44 89 7b 42=
=20
[ 1985.760315] RIP  [<ffffffffa0da23e0>] media_entity_init+0x40/0xa0 [media]
[ 1985.760325]  RSP <ffff88013a657bc8>
[ 1985.760328] CR2: 0000000000000050
[ 1985.760383] ---[ end trace d9254fd075095138 ]---

--KsGdsel6WgEHnImy--

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQEcBAEBAgAGBQJOBjTBAAoJEKYW3KHXK+l3ukkH/iKQHCUHDY70Q7Bts7u/rpLG
KINhccLw0EhvG6Oh2TCIsW4TV3NhnrhE56t5RH7oU1Y40g39SMTx8fYBlaBXO41Y
3jJJ4QKQ04V9rOJIGHqu2r+HWfFawpQHFcT5GYfTU1fr7iG1W4DkbGFRq9iA9mUq
L11Y2+02B0piuLUEeG0FqDDaQ7cGIehatGnbuZOhIMIhzW5J0VXTDF0C2JP7izZh
soT2Ep7vZ6QqnDXEOJzAZBELX32wQHS3Pe3tgOq9Xywqo5xvqBbfS1g87grlkA8c
N73uL/q1cQry4idxRuKFOOA2aMQ4UPX6vqQCThohh/RLuHc9TtxwTm1PP2plE8I=
=bonC
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
