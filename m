Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2HYCla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 22:41:30 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35921 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2HYClW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 22:41:22 -0400
Message-ID: <1345862471.2941.37.camel@cl-773.udi-01.br.sixxs.net>
Subject: PROBLEM: at drivers/gpu/drm/ttm/ttm_bo.c:1659
From: Iuri Rezende Souza <iuri.ena@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: iuri.ena@gmail.com
Date: Fri, 24 Aug 2012 23:41:11 -0300
Content-Type: multipart/mixed; boundary="=-2olrZock3VUshPkdUg0g"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2olrZock3VUshPkdUg0g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

The computer stops after trying to close a graphical program.

Recently I installed some GNOME games on my computer and I tried them. I
played /usr/bin/gnibbles and checked for the highest scores. None
appeared and when I tried to close the window, the computer stopped. The
screen displayed a message which I retrieved from /var/log/messages and
is in the attachment travou.log. I noticed that the original message had
the call trace, which doesn't appear in the retrieved log. Also, I
noticed a kind of an interruption in the last line.

I successfully tried to reproduce the problem. The second screen message
was badly formatted, i.e. the lines started on the right and ended on
the left. I tried switching the terminals by pressing Ctrl+Alt+F1-12 and
it didn't work. On both errors the mouse cursor was stopped in front of
the message. The retrieved message from /var/log/messages, though, was
more complete, as it can be checked on the attachment travou2.log

Then I looked for the 'oops' directory and I found the same message on
the file backtrace. The first error also had an 'oops' directory, but
the files were empty. If you think these files will help on diagnosing
the problem, ask me for them.

Keywords: gnome gui gnibbles drivers gpu drm ttm ttm_bo.c

Content of /proc/version
Linux version 3.5.2-3.fc17.x86_64 (mockbuild@) (gcc version 4.7.0
20120507 (Red Hat 4.7.0-5) (GCC) ) #1 SMP Tue Aug 21 19:06:52 UTC 2012

As you might see, I use Fedora distribution and my window manager is
GNOME. Since the computer stopped by using a graphical program, this
information might be useful on reproducing the problem.

Content of /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 30
model name	: Intel(R) Core(TM) i5 CPU         750  @ 2.67GHz
stepping	: 5
microcode	: 0x5
cpu MHz		: 1200.000
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3
cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dtherm tpr_shadow vnmi
flexpriority ept vpid
bogomips	: 5320.30
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 30
model name	: Intel(R) Core(TM) i5 CPU         750  @ 2.67GHz
stepping	: 5
microcode	: 0x5
cpu MHz		: 1200.000
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3
cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dtherm tpr_shadow vnmi
flexpriority ept vpid
bogomips	: 5320.30
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 30
model name	: Intel(R) Core(TM) i5 CPU         750  @ 2.67GHz
stepping	: 5
microcode	: 0x5
cpu MHz		: 1200.000
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 4
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3
cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dtherm tpr_shadow vnmi
flexpriority ept vpid
bogomips	: 5320.30
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 30
model name	: Intel(R) Core(TM) i5 CPU         750  @ 2.67GHz
stepping	: 5
microcode	: 0x5
cpu MHz		: 1200.000
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 6
initial apicid	: 6
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3
cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dtherm tpr_shadow vnmi
flexpriority ept vpid
bogomips	: 5320.30
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

I will attach the content of /proc/modules, since many lines were
wrapped

Content of /proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  03c0-03df : vesafb
  0400-041f : 0000:00:1f.3
    0400-041f : i801_smbus
  04d0-04d1 : pnp 00:07
  0500-057f : gpio_ich
    0500-057f : pnp 00:07
  0800-087f : pnp 00:07
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0820-082f : ACPI GPE0_BLK
    0850-0850 : ACPI PM2_CNT_BLK
  0a00-0a0f : pnp 00:06
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-1fff : PCI Bus 0000:04
  b400-b41f : 0000:00:1f.2
    b400-b41f : ahci
  b480-b483 : 0000:00:1f.2
    b480-b483 : ahci
  b800-b807 : 0000:00:1f.2
    b800-b807 : ahci
  b880-b883 : 0000:00:1f.2
    b880-b883 : ahci
  bc00-bc07 : 0000:00:1f.2
    bc00-bc07 : ahci
  c000-cfff : PCI Bus 0000:01
    c000-c0ff : 0000:01:00.0
  d000-dfff : PCI Bus 0000:02
    d800-d8ff : 0000:02:00.0
      d800-d8ff : r8169
  e000-efff : PCI Bus 0000:03
    e800-e8ff : 0000:03:00.0

Content of /proc/iomem
00000000-0000ffff : reserved
00010000-000957ff : System RAM
00095800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000ce7ff : Video ROM
000ce800-000cf7ff : Adapter ROM
000cf800-000d6bff : Adapter ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-cd77ffff : System RAM
  01000000-016189b1 : Kernel code
  016189b2-01cdff7f : Kernel data
  01de6000-01f99fff : Kernel bss
cd780000-cd78dfff : ACPI Tables
cd78e000-cd7cffff : ACPI Non-volatile Storage
cd7d0000-cd7dffff : reserved
cd7e0000-cd7ecfff : RAM buffer
cd7ed000-cdffffff : reserved
ce000000-dfffffff : PCI Bus 0000:00
  ce000000-ce1fffff : PCI Bus 0000:03
  ce200000-ce3fffff : PCI Bus 0000:04
  d0000000-dfffffff : PCI Bus 0000:01
    d0000000-dfffffff : 0000:01:00.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : pnp 00:0a
f0000000-fed8ffff : PCI Bus 0000:00
  faf00000-faffffff : PCI Bus 0000:02
    faffc000-faffffff : 0000:02:00.0
      faffc000-faffffff : r8169
  fbbf4000-fbbf47ff : 0000:00:1f.2
    fbbf4000-fbbf47ff : ahci
  fbbf6000-fbbf63ff : 0000:00:1d.0
    fbbf6000-fbbf63ff : ehci_hcd
  fbbf8000-fbbfbfff : 0000:00:1b.0
    fbbf8000-fbbfbfff : ICH HD audio
  fbbfc000-fbbfc3ff : 0000:00:1a.0
    fbbfc000-fbbfc3ff : ehci_hcd
  fbbff800-fbbff8ff : 0000:00:1f.3
  fbbffc00-fbbffc0f : 0000:00:16.0
    fbbffc00-fbbffc0f : mei
  fbc00000-fbcfffff : PCI Bus 0000:01
    fbcbc000-fbcbffff : 0000:01:00.1
      fbcbc000-fbcbffff : ICH HD audio
    fbcc0000-fbcdffff : 0000:01:00.0
    fbce0000-fbcfffff : 0000:01:00.0
  fbd00000-fbdfffff : PCI Bus 0000:02
    fbdc0000-fbddffff : 0000:02:00.0
    fbdff000-fbdfffff : 0000:02:00.0
      fbdff000-fbdfffff : r8169
  fbe00000-fbefffff : PCI Bus 0000:03
    fbeff800-fbefffff : 0000:03:00.0
      fbeff800-fbefffff : firewire_ohci
  fbf00000-fbffffff : PCI Bus 0000:04
    fbff0000-fbffffff : 0000:04:00.0
      fbff0000-fbffffff : 0000:04:00.0
  fc000000-fcffffff : pnp 00:01
  fd000000-fdffffff : pnp 00:01
  fe000000-febfffff : pnp 00:01
  fec00000-fec003ff : IOAPIC 0
  fed00000-fed003ff : HPET 0
  fed14000-fed19fff : pnp 00:01
  fed1c000-fed1ffff : pnp 00:07
  fed20000-fed3ffff : pnp 00:07
  fed40000-fed8ffff : pnp 00:07
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:09
ffe00000-ffffffff : reserved
100000000-12fffffff : System RAM

The output of "su -c \'lspci -vvvv\'" is very big, so I put it in the
attachment lspci.

Content of /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST31000528AS     Rev: HP35
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: hp       Model: CDDVDW TS-H653T  Rev: H6D1
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic- Model: SD/MMC           Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi6 Channel: 00 Id: 00 Lun: 01
  Vendor: Generic- Model: Compact Flash    Rev: 1.01
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi6 Channel: 00 Id: 00 Lun: 02
  Vendor: Generic- Model: SM/xD-Picture    Rev: 1.02
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi6 Channel: 00 Id: 00 Lun: 03
  Vendor: Generic- Model: MS/MS-Pro        Rev: 1.03
  Type:   Direct-Access                    ANSI  SCSI revision: 00

I don't speak English as a native language. Sorry for any language
inconveniences.
Please include a CC to me on the reply.

-- 
Iuri Rezende Souza <iuri.ena@gmail.com>

--=-2olrZock3VUshPkdUg0g
Content-Disposition: attachment; filename="travou.log"
Content-Type: text/x-log; name="travou.log"; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Aug 24 21:48:17 cl-773 kernel: [48310.906223] ------------[ cut here ]-----=
-------
Aug 24 21:48:17 cl-773 kernel: [48310.906249] kernel BUG at drivers/gpu/drm=
/ttm/ttm_bo.c:1659!
Aug 24 21:48:17 cl-773 kernel: [48310.906273] invalid opcode: 0000 [#1] SMP
Aug 24 21:48:17 cl-773 kernel: [48310.906295] CPU 0
Aug 24 21:48:17 cl-773 kernel: [48310.906303] Modules linked in: cdc_acm vf=
at fat lockd sunrpc bnep sit tunnel4 bluetooth ebtable_nat ebtables be2iscs=
i iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio libcxgbi i=
b_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_=
tcp libiscsi tpm_bios scsi_transport_iscsi ipt_MASQUERADE iptable_nat nf_na=
t xt_CHECKSUM iptable_mangle bridge stp llc ip6t_REJECT nf_conntrack_ipv6 n=
f_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6tab=
le_filter ip6_tables fuse snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_=
intel snd_hda_codec snd_hwdep snd_pcm i7core_edac edac_core arc4 rt2800pci =
rt2800lib rt2x00pci rt2x00lib eeprom_93cx6 mac80211 snd_page_alloc snd_time=
r cfg80211 rfkill crc_ccitt snd coretemp serio_raw lpc_ich mfd_core soundco=
re i2c_i801 r8169 mii mei microcode vhost_net tun macvtap macvlan kvm binfm=
t_misc uinput crc32c_intel usb_storage firewire_ohci firewire_core crc_itu_=
t wmi radeon i2c_algo_bit drm_kms_helper ttm drm i2c
Aug 24 21:48:17 cl-773 kernel: _core [last unloaded: scsi_wait_scan]
Aug 24 21:48:17 cl-773 kernel: [48310.906872]
Aug 24 21:48:17 cl-773 kernel: [48310.906880] Pid: 30050, comm: Xorg Not ta=
inted 3.5.2-1.fc17.x86_64 #1 Hewlett-Packard p6760br/2A9C
Aug 24 21:48:17 cl-773 kernel: [48310.906914] RIP: 0010:[<ffffffffa0068547>=
]  [<ffffffffa0068547>] ttm_bo_init+0x337/0x3e0 [ttm]
Aug 24 21:48:17 cl-773 kernel: [48310.906949] RSP: 0018:ffff88010eb33bb8  E=
FLAGS: 00010246
Aug 24 21:48:17 cl-773 kernel: [48310.906967] RAX: ffff880013a47188 RBX: ff=
ff880013a47020 RCX: ffff880126089588
Aug 24 21:48:17 cl-773 kernel: [48310.906989] RDX: ffff88004b02fd00 RSI: ff=
ff880126062990 RDI: 000000000013cb3a
Aug 24 21:48:17 cl-773 kernel: [48310.907011] RBP: ffff88010eb33c08 R08: ff=
ff88000252a290 R09: ffff88004b02fd00
Aug 24 21:48:17 cl-773 kernel: [48310.907034] R10: 0000000000000002 R11: 00=
0000000013cff2 R12: ffff880126062560
Aug 24 21:48:17 cl-773 kernel: [48310.907056] R13: ffff880126062998 R14: ff=
ff880013a47048 R15: ffff880126062580
Aug 24 21:48:17 cl-773 kernel: [48310.907079] FS:  00007ffdf9aea8c0(0000) G=
S:ffff88012fc00000(0000) knlGS:0000000000000000
Aug 24 21:48:17 cl-773 kernel: [48310.907104] CS:  0010 DS: 0000 ES: 0000 C=
R0: 0000000080050033
Aug 24 21:48:17 cl-773 kernel: [48310.907122] CR2: 00007ffdf5945000 CR3: 00=
000001086ec000 CR4: 00000000000007f0
Aug 24 21:48:17 cl-773 kernel: [48310.907145] DR0: 0000000000000000 DR1: 00=
00000000000000 DR2: 0000000000000000
Aug 24 21:48:17 cl-773 kernel: [48310.907167] DR3: 0000000000000000 DR6: 00=
000000ffff0ff0 DR7: 0000000000000400
Aug 24 21:48:17 cl-773 kernel: [48310.907190] Process Xorg (pid: 30050, thr=
eadinfo ffff88010eb32000, task ffff880034232e20)
Aug 24 21:48:17 cl-773 kernel: [48310.907215] Stack:
Aug 24 21:48:17 cl-773 kernel: [48310.907223]  ffff88010eb33bd8 01ff880013a=
47218 ffff880125057d80 ffff880013a47048
Aug 24 21:48:17 cl-773 kernel: [48310.907254]  ffff880013a47000 ffff8801260=
62000 0000000000000000 0000000000001000
Aug 2Aug 24 21:52:42 cl-773 kernel: imklog 5.8.10, log source =3D /proc/kms=
g started.


--=-2olrZock3VUshPkdUg0g
Content-Disposition: attachment; filename="travou2.log"
Content-Type: text/x-log; name="travou2.log"; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Aug 24 22:15:07 cl-773 kernel: [ 1380.330809] ------------[ cut here ]-----=
-------
Aug 24 22:15:07 cl-773 kernel: [ 1380.330860] kernel BUG at drivers/gpu/drm=
/ttm/ttm_bo.c:1659!
Aug 24 22:15:07 cl-773 kernel: [ 1380.330910] invalid opcode: 0000 [#1] SMP
Aug 24 22:15:07 cl-773 kernel: [ 1380.330955] CPU 2
Aug 24 22:15:07 cl-773 kernel: [ 1380.330975] Modules linked in: ebtable_na=
t ebtables be2iscsi iscsi_boot_sysfs ipt_MASQUERADE bnx2i iptable_nat nf_na=
t cnic uio cxgb4i cxgb4 lockd cxgb3i sunrpc cxgb3 mdio libcxgbi ib_iser bne=
p bluetooth xt_CHECKSUM sit tunnel4 rdma_cm ib_addr iw_cm ib_cm ib_sa ib_ma=
d ib_core iptable_mangle iscsi_tcp libiscsi_tcp tpm_bios libiscsi scsi_tran=
sport_iscsi bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_=
conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tab=
les fuse arc4 rt2800pci rt2800lib rt2x00pci rt2x00lib eeprom_93cx6 mac80211=
 snd_hda_codec_hdmi cfg80211 rfkill crc_ccitt snd_hda_codec_realtek i7core_=
edac lpc_ich snd_hda_intel edac_core vhost_net tun mei macvtap snd_hda_code=
c mfd_core snd_hwdep r8169 macvlan coretemp i2c_i801 snd_pcm snd_page_alloc=
 snd_timer mii kvm snd microcode soundcore serio_raw uinput binfmt_misc crc=
32c_intel usb_storage firewire_ohci firewire_core crc_itu_t wmi radeon i2c_=
algo_bit drm_kms_helper ttm drm i2c_core [last unloa
Aug 24 22:15:07 cl-773 kernel: ded: scsi_wait_scan]
Aug 24 22:15:07 cl-773 kernel: [ 1380.331853]
Aug 24 22:15:07 cl-773 kernel: [ 1380.331856] Pid: 1553, comm: gnome-shell =
Not tainted 3.5.2-3.fc17.x86_64 #1 Hewlett-Packard p6760br/2A9C
Aug 24 22:15:07 cl-773 kernel: [ 1380.331860] RIP: 0010:[<ffffffffa0068547>=
]  [<ffffffffa0068547>] ttm_bo_init+0x337/0x3e0 [ttm]
Aug 24 22:15:07 cl-773 kernel: [ 1380.331874] RSP: 0018:ffff88010e6ebbb8  E=
FLAGS: 00010246
Aug 24 22:15:07 cl-773 kernel: [ 1380.331875] RAX: ffff880063ca3588 RBX: ff=
ff880063ca3420 RCX: ffff8800c5ecb988
Aug 24 22:15:07 cl-773 kernel: [ 1380.331876] RDX: ffff88004f3f3780 RSI: ff=
ff8801267f6990 RDI: 000000000013365e
Aug 24 22:15:07 cl-773 kernel: [ 1380.331878] RBP: ffff88010e6ebc08 R08: ff=
ff88004eaf9f50 R09: ffff88004f3f3780
Aug 24 22:15:07 cl-773 kernel: [ 1380.331879] R10: 0000000000000002 R11: 00=
000000001337a9 R12: ffff8801267f6560
Aug 24 22:15:07 cl-773 kernel: [ 1380.331880] R13: ffff8801267f6998 R14: ff=
ff880063ca3448 R15: ffff8801267f6580
Aug 24 22:15:07 cl-773 kernel: [ 1380.331883] FS:  00007f4c6ef649c0(0000) G=
S:ffff88012fc80000(0000) knlGS:0000000000000000
Aug 24 22:15:07 cl-773 kernel: [ 1380.331884] CS:  0010 DS: 0000 ES: 0000 C=
R0: 0000000080050033
Aug 24 22:15:07 cl-773 kernel: [ 1380.331887] CR2: 00007f4c64bc0000 CR3: 00=
0000010e7b9000 CR4: 00000000000007e0
Aug 24 22:15:07 cl-773 kernel: [ 1380.331888] DR0: 0000000000000000 DR1: 00=
00000000000000 DR2: 0000000000000000
Aug 24 22:15:07 cl-773 kernel: [ 1380.331892] DR3: 0000000000000000 DR6: 00=
000000ffff0ff0 DR7: 0000000000000400
Aug 24 22:15:07 cl-773 kernel: [ 1380.331894] Process gnome-shell (pid: 155=
3, threadinfo ffff88010e6ea000, task ffff8801261dc530)
Aug 24 22:15:07 cl-773 kernel: [ 1380.331895] Stack:
Aug 24 22:15:07 cl-773 kernel: [ 1380.331896]  ffff88010e6ebbd8 01ff880063c=
a3618 ffff880125316840 ffff880063ca3448
Aug 24 22:15:07 cl-773 kernel: [ 1380.331900]  ffff880063ca3400 ffff8801267=
f6000 0000000000000000 0000000000002000
Aug 24 22:15:07 cl-773 kernel: [ 1380.331904]  ffff880063ca3400 00000000000=
00001 ffff88010e6ebcb8 ffffffffa00a9617
Aug 24 22:15:07 cl-773 kernel: [ 1380.331908] Call Trace:
Aug 24 22:15:07 cl-773 kernel: [ 1380.331912]  [<ffffffffa00a9617>] radeon_=
bo_create+0x1c7/0x2d0 [radeon]
Aug 24 22:15:07 cl-773 kernel: [ 1380.331941]  [<ffffffffa00a92e0>] ? radeo=
n_bo_clear_va+0x80/0x80 [radeon]
Aug 24 22:15:07 cl-773 kernel: [ 1380.331968]  [<ffffffffa00bb401>] radeon_=
gem_object_create+0x61/0x100 [radeon]
Aug 24 22:15:07 cl-773 kernel: [ 1380.331997]  [<ffffffffa00bb7ce>] radeon_=
gem_create_ioctl+0x5e/0xf0 [radeon]
Aug 24 22:15:07 cl-773 kernel: [ 1380.332027]  [<ffffffffa00154f3>] drm_ioc=
tl+0x4d3/0x580 [drm]
Aug 24 22:15:07 cl-773 kernel: [ 1380.332040]  [<ffffffff81154550>] ? mmap_=
region+0x2c0/0x5b0
Aug 24 22:15:07 cl-773 kernel: [ 1380.332050]  [<ffffffffa00bb770>] ? radeo=
n_gem_pwrite_ioctl+0x30/0x30 [radeon]
Aug 24 22:15:07 cl-773 kernel: [ 1380.332078]  [<ffffffff816103ec>] ? do_pa=
ge_fault+0x1bc/0x4b0
Aug 24 22:15:07 cl-773 kernel: [ 1380.332081]  [<ffffffff811996c9>] do_vfs_=
ioctl+0x99/0x580
Aug 24 22:15:07 cl-773 kernel: [ 1380.332085]  [<ffffffff812793da>] ? inode=
_has_perm.isra.31.constprop.61+0x2a/0x30
Aug 24 22:15:07 cl-773 kernel: [ 1380.332089]  [<ffffffff8127a9b7>] ? file_=
has_perm+0x97/0xb0
Aug 24 22:15:07 cl-773 kernel: [ 1380.332093]  [<ffffffff81199c49>] sys_ioc=
tl+0x99/0xa0
Aug 24 22:15:07 cl-773 kernel: [ 1380.332095]  [<ffffffff81614969>] system_=
call_fastpath+0x16/0x1b
Aug 24 22:15:07 cl-773 kernel: [ 1380.332100] Code: e8 cf fb ff ff 85 c0 0f=
 85 6f ff ff ff 48 8b 7d c8 89 45 b0 e8 9b e5 ff ff 8b 45 b0 48 83 c4 28 5b=
 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b 8b 43 04 2b 03 49 39 46 78 0f 86 7a =
fe ff ff 0f 0b 48 c7
Aug 24 22:15:07 cl-773 kernel: [ 1380.332140] RIP  [<ffffffffa0068547>] ttm=
_bo_init+0x337/0x3e0 [ttm]
Aug 24 22:15:07 cl-773 kernel: [ 1380.332150]  RSP <ffff88010e6ebbb8>
Aug 24 22:15:07 cl-773 kernel: [ 1380.345891] ---[ end trace 3df5deb93e684d=
11 ]---
Aug 24 22:15:08 cl-773 sh[749]: abrt-dump-oops: Found oopses: 1
Aug 24 22:15:08 cl-773 sh[749]: abrt-dump-oops: Creating dump directories
Aug 24 22:15:08 cl-773 abrtd: Directory 'oops-2012-08-24-22:15:08-2962-0' c=
reation detected
Aug 24 22:15:08 cl-773 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Aug 24 22:15:08 cl-773 abrtd: Can't open file '/var/spool/abrt/oops-2012-08=
-24-22:15:08-2962-0/uid': Arquivo ou diret=C3=83=C2=B3rio n=C3=83=C2=A3o en=
contrado
Aug 24 22:15:09 cl-773 abrtd: New problem directory /var/spool/abrt/oops-20=
12-08-24-22:15:08-2962-0, processing
Aug 24 22:15:09 cl-773 abrtd: Can't open file '/var/spool/abrt/oops-2012-08=
-24-22:15:08-2962-0/uid': Arquivo ou diret=C3=83=C2=B3rio n=C3=83=C2=A3o en=
contrado
Aug 24 22:16:11 cl-773 kernel: [ 1443.703702] SysRq : HELP : loglevel(0-9) =
reBoot Crash terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(=
I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-us=
age(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) u=
nRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dum=
p-ftrace-buffer(Z)
Aug 24 22:16:14 cl-773 kernel: [ 1446.752298] SysRq : Keyboard mode set to =
system default
Aug 24 22:16:17 cl-773 kernel: [ 1450.167969] SysRq : Terminate All Tasks
Aug 24 22:16:17 cl-773 kernel: Kernel logging (proc) stopped.


--=-2olrZock3VUshPkdUg0g
Content-Disposition: attachment; filename="modules"
Content-Type: text/plain; name="modules"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

lockd 89250 0 - Live 0xffffffffa06c1000
sunrpc 255029 1 lockd, Live 0xffffffffa066d000
ebtable_nat 12807 0 - Live 0xffffffffa05e4000
ebtables 30757 1 ebtable_nat, Live 0xffffffffa0664000
bnep 19584 2 - Live 0xffffffffa060d000
sit 21773 0 - Live 0xffffffffa065d000
tunnel4 13138 1 sit, Live 0xffffffffa05a8000
bluetooth 298929 7 bnep, Live 0xffffffffa0613000
be2iscsi 81803 0 - Live 0xffffffffa05f8000
iscsi_boot_sysfs 15641 1 be2iscsi, Live 0xffffffffa0559000
bnx2i 54642 0 - Live 0xffffffffa05e9000
cnic 62653 1 bnx2i, Live 0xffffffffa05d3000
uio 19044 1 cnic, Live 0xffffffffa0594000
cxgb4i 32879 0 - Live 0xffffffffa05c9000
cxgb4 108529 1 cxgb4i, Live 0xffffffffa05ad000
cxgb3i 32950 0 - Live 0xffffffffa059e000
cxgb3 155601 1 cxgb3i, Live 0xffffffffa056d000
mdio 13398 1 cxgb3, Live 0xffffffffa0549000
libcxgbi 56447 2 cxgb4i,cxgb3i, Live 0xffffffffa055e000
ib_iser 37812 0 - Live 0xffffffffa054e000
rdma_cm 42026 1 ib_iser, Live 0xffffffffa053d000
ib_addr 13745 1 rdma_cm, Live 0xffffffffa0538000
iw_cm 18221 1 rdma_cm, Live 0xffffffffa0523000
ib_cm 41725 1 rdma_cm, Live 0xffffffffa052c000
ib_sa 28484 2 rdma_cm,ib_cm, Live 0xffffffffa050d000
ib_mad 46340 2 ib_cm,ib_sa, Live 0xffffffffa0516000
ib_core 73894 6 ib_iser,rdma_cm,iw_cm,ib_cm,ib_sa,ib_mad, Live 0xffffffffa04f9000
iscsi_tcp 18333 0 - Live 0xffffffffa04ef000
libiscsi_tcp 24128 4 cxgb4i,cxgb3i,libcxgbi,iscsi_tcp, Live 0xffffffffa04d9000
libiscsi 50542 8 be2iscsi,bnx2i,cxgb4i,cxgb3i,libcxgbi,ib_iser,iscsi_tcp,libiscsi_tcp, Live 0xffffffffa04e1000
scsi_transport_iscsi 57490 8 be2iscsi,bnx2i,libcxgbi,ib_iser,iscsi_tcp,libiscsi, Live 0xffffffffa04c9000
tpm_bios 13528 0 - Live 0xffffffffa04c4000
ipt_MASQUERADE 12880 3 - Live 0xffffffffa04bf000
iptable_nat 13383 1 - Live 0xffffffffa04ba000
nf_nat 25221 2 ipt_MASQUERADE,iptable_nat, Live 0xffffffffa04ae000
xt_CHECKSUM 12549 1 - Live 0xffffffffa04a0000
iptable_mangle 12695 1 - Live 0xffffffffa04a9000
bridge 91059 0 - Live 0xffffffffa0488000
stp 12823 1 bridge, Live 0xffffffffa0483000
llc 14045 2 bridge,stp, Live 0xffffffffa0469000
nf_conntrack_ipv4 14744 11 iptable_nat,nf_nat, Live 0xffffffffa0464000
nf_defrag_ipv4 12673 1 nf_conntrack_ipv4, Live 0xffffffffa047e000
ip6t_REJECT 12939 2 - Live 0xffffffffa0479000
nf_conntrack_ipv6 14341 8 - Live 0xffffffffa0470000
nf_defrag_ipv6 18177 1 nf_conntrack_ipv6, Live 0xffffffffa045e000
xt_state 12578 16 - Live 0xffffffffa0438000
nf_conntrack 83563 6 ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4,nf_conntrack_ipv6,xt_state, Live 0xffffffffa0448000
ip6table_filter 12815 1 - Live 0xffffffffa0376000
ip6_tables 26942 1 ip6table_filter, Live 0xffffffffa0440000
fuse 77952 5 - Live 0xffffffffa0423000
arc4 12529 2 - Live 0xffffffffa041e000
rt2800pci 18528 0 - Live 0xffffffffa0370000
rt2800lib 56802 1 rt2800pci, Live 0xffffffffa040f000
rt2x00pci 13995 1 rt2800pci, Live 0xffffffffa0316000
rt2x00lib 66421 3 rt2800pci,rt2800lib,rt2x00pci, Live 0xffffffffa03fd000
eeprom_93cx6 13088 1 rt2800pci, Live 0xffffffffa030b000
mac80211 521833 3 rt2800lib,rt2x00pci,rt2x00lib, Live 0xffffffffa037c000
cfg80211 192203 2 rt2x00lib,mac80211, Live 0xffffffffa0340000
rfkill 21384 4 bluetooth,cfg80211, Live 0xffffffffa02fd000
crc_ccitt 12573 1 rt2800lib, Live 0xffffffffa02e9000
mei 75591 0 - Live 0xffffffffa032c000
r8169 61608 0 - Live 0xffffffffa031b000
lpc_ich 17061 0 - Live 0xffffffffa0310000
coretemp 13480 0 - Live 0xffffffffa0306000
i2c_i801 17779 0 - Live 0xffffffffa02f7000
i7core_edac 23571 0 - Live 0xffffffffa02f0000
edac_core 50969 3 i7core_edac, Live 0xffffffffa02db000
mfd_core 13145 1 lpc_ich, Live 0xffffffffa028e000
mii 13527 1 r8169, Live 0xffffffffa0236000
snd_hda_codec_hdmi 36103 1 - Live 0xffffffffa02d1000
snd_hda_codec_realtek 77727 1 - Live 0xffffffffa02bd000
snd_hda_intel 37587 4 - Live 0xffffffffa0269000
snd_hda_codec 126728 3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 0xffffffffa029d000
snd_hwdep 17650 1 snd_hda_codec, Live 0xffffffffa0297000
snd_pcm 97292 4 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0xffffffffa0275000
snd_page_alloc 18101 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0263000
snd_timer 28690 1 snd_pcm, Live 0xffffffffa0242000
snd 79242 14 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer, Live 0xffffffffa024e000
soundcore 14491 1 snd, Live 0xffffffffa0231000
serio_raw 13375 0 - Live 0xffffffffa022c000
microcode 23435 0 - Live 0xffffffffa023b000
vhost_net 33778 0 - Live 0xffffffffa0222000
tun 22891 2 vhost_net, Live 0xffffffffa0217000
macvtap 18240 1 vhost_net, Live 0xffffffffa0211000
macvlan 18731 1 macvtap, Live 0xffffffffa0207000
kvm 412517 0 - Live 0xffffffffa01a1000
binfmt_misc 17463 1 - Live 0xffffffffa019b000
uinput 17673 0 - Live 0xffffffffa0192000
crc32c_intel 12901 0 - Live 0xffffffffa016d000
usb_storage 56353 0 - Live 0xffffffffa0183000
firewire_ohci 40401 0 - Live 0xffffffffa0174000
firewire_core 62298 1 firewire_ohci, Live 0xffffffffa015c000
crc_itu_t 12579 1 firewire_core, Live 0xffffffffa0155000
wmi 18697 0 - Live 0xffffffffa000b000
radeon 894879 3 - Live 0xffffffffa0079000
i2c_algo_bit 13257 1 radeon, Live 0xffffffffa005d000
drm_kms_helper 40253 1 radeon, Live 0xffffffffa0052000
ttm 79760 1 radeon, Live 0xffffffffa0064000
drm 259168 5 radeon,drm_kms_helper,ttm, Live 0xffffffffa0011000
i2c_core 38177 5 i2c_i801,radeon,i2c_algo_bit,drm_kms_helper,drm, Live 0xffffffffa0000000

--=-2olrZock3VUshPkdUg0g
Content-Disposition: attachment; filename="lspci"
Content-Type: text/plain; name="lspci"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

00:00.0 Host bridge: Intel Corporation Core Processor DMI (rev 11)
	Subsystem: Hewlett-Packard Company Device 2a9c
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] #00 [0000]

00:03.0 PCI bridge: Intel Corporation Core Processor PCI Express Root Port 1 (rev 11) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fbc00000-fbcfffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Hewlett-Packard Company Device 2a9c
	Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Kernel driver in use: pcieport

00:08.0 System peripheral: Intel Corporation Core Processor System Management Registers (rev 11)
	Subsystem: Device 003c:009c
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v0] Vendor Specific Information: ID=0000 Rev=0 Len=000 <?>

00:08.1 System peripheral: Intel Corporation Core Processor Semaphore and Scratchpad Registers (rev 11)
	Subsystem: Device 003c:009c
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v0] Vendor Specific Information: ID=0000 Rev=0 Len=000 <?>

00:08.2 System peripheral: Intel Corporation Core Processor System Control and Status Registers (rev 11)
	Subsystem: Device 003c:009c
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v0] Vendor Specific Information: ID=0000 Rev=0 Len=000 <?>

00:08.3 System peripheral: Intel Corporation Core Processor Miscellaneous Registers (rev 11)
	Subsystem: Device 003c:009c
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:10.0 System peripheral: Intel Corporation Core Processor QPI Link (rev 11)
	Subsystem: Device 003c:009c
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:10.1 System peripheral: Intel Corporation Core Processor QPI Routing and Protocol Registers (rev 11)
	Subsystem: Device 003c:009c
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
	Subsystem: Hewlett-Packard Company Device 2a9c
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 50
	Region 0: Memory at fbbffc00 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41b9
	Kernel driver in use: mei

00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 2a9c
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fbbfc000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 06)
	Subsystem: Hewlett-Packard Company Device 2a9c
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 47
	Region 0: Memory at fbbf8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41a1
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=2 ArbSelect=Fixed TC/VC=04
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 06) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000faf00000-00000000faffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #128, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 2a9c
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 3 (rev 06) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbe00000-fbefffff
	Prefetchable memory behind bridge: 00000000ce000000-00000000ce1fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #130, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 2a9c
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 06) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: fbf00000-fbffffff
	Prefetchable memory behind bridge: 00000000ce200000-00000000ce3fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #133, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 2a9c
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 2a9c
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fbbf6000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a6) (prog-if 01 [Subtractive decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Hewlett-Packard Company Device 2a9c

00:1f.0 ISA bridge: Intel Corporation 5 Series Chipset LPC Interface Controller (rev 06)
	Subsystem: Hewlett-Packard Company Device 2a9c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=10 <?>
	Kernel driver in use: lpc_ich

00:1f.2 RAID bus controller: Intel Corporation 82801 SATA RAID Controller (rev 06)
	Subsystem: Hewlett-Packard Company Device 2a9c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 45
	Region 0: I/O ports at bc00 [size=8]
	Region 1: I/O ports at b880 [size=4]
	Region 2: I/O ports at b800 [size=8]
	Region 3: I/O ports at b480 [size=4]
	Region 4: I/O ports at b400 [size=32]
	Region 5: Memory at fbbf4000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4189
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 06)
	Subsystem: Hewlett-Packard Company Device 2a9c
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbbff800 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 0400 [size=32]
	Kernel driver in use: i801_smbus

01:00.0 VGA compatible controller: ATI Technologies Inc Redwood PRO [Radeon HD 5500 Series] (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device 6872
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 46
	Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 2: Memory at fbce0000 (64-bit, non-prefetchable) [size=128K]
	Region 4: I/O ports at c000 [size=256]
	Expansion ROM at fbcc0000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 4191
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [150 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: radeon

01:00.1 Audio device: ATI Technologies Inc Redwood HDMI Audio [Radeon HD 5600 Series]
	Subsystem: Hewlett-Packard Company Device aa60
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 48
	Region 0: Memory at fbcbc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41a9
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [150 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: snd_hda_intel

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 2a9c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 49
	Region 0: I/O ports at d800 [size=256]
	Region 2: Memory at fbdff000 (64-bit, non-prefetchable) [size=4K]
	Region 4: Memory at faffc000 (64-bit, prefetchable) [size=16K]
	Expansion ROM at fbdc0000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 41b1
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [ac] MSI-X: Enable- Count=4 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [cc] Vital Product Data
		Unknown small resource type 05, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 08-00-00-00-68-4c-e0-00
	Kernel driver in use: r8169

03:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6315 Series Firewire Controller (rev 01) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 2a90
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fbeff800 (64-bit, non-prefetchable) [size=2K]
	Region 2: I/O ports at e800 [size=256]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [98] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [130 v1] Device Serial Number 00-60-b0-ff-ff-79-cf-44
	Kernel driver in use: firewire_ohci

04:00.0 Network controller: Ralink corp. RT3090 Wireless 802.11n 1T/1R PCIe
	Subsystem: Lite-On Communications Inc Device 6632
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fbff0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-00-76-22-26-a1-f1-70
	Kernel driver in use: rt2800pci

ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-Core Registers (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Kernel driver in use: i7core_edac

ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Target Address Decoder (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.4 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Test Registers (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Control Registers (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Address Registers (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.2 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Rank Registers (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.3 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Thermal Control Registers (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Control Registers (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Address Registers (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.2 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Rank Registers (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.3 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Thermal Control Registers (rev 04)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0


--=-2olrZock3VUshPkdUg0g--

