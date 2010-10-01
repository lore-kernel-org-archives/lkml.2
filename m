Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab0JAO2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:28:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60932 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0JAO23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:openpgp:content-type;
        b=tIe6y6g6Vu4ggT8iwWMSqcBGUHg5HeUj6p+ALQGz7QisJK9reNnemyImgbNinjPbI7
         N/FhwlVgzU+R5gGKtZNbD9ijirJWLeiLzIXmecPl09o51TsBCsHLfFETQ0leax2UOrwB
         vUyLC4mfDQsOsVzz4UsgwUkcCkOJDTH6CzI+4=
Message-ID: <4CA5F009.5090608@gmail.com>
Date: Fri, 01 Oct 2010 16:28:25 +0200
From: Sandro Weiser <psi.systems@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.8.1.22) Gecko/20091109 Lightning/0.9 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NP when accessing dvd/cdrom-drive
X-Enigmail-Version: 1.1.2
OpenPGP: id=25B9CBF1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090808060206050404030908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090808060206050404030908
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

First I thought my drive doesn't gets enough power, because I had
problems with my power supply: it has a cable which has contact
problems. So I attached my drive to another cable, so the problems (hard
drives spin downs) went away. But after some time with no problems I
always got kernel NP faults, so I can't use my drive any more. Now I
need it and attached the drive to other cables, because I thought the
problems might be a result of this change, but the NP faults don't go awa=
y.
I can't boot windows on the computer to test the drive there.

To produce the NP faults I only need to insert some cd/dvd or read from
a cd/dvd or burn a dvd (cd not tested).

Can any one help me or give me a hint how to fix this?

Sandro

Oct  1 12:49:56 x545 vmunix: BUG: unable to handle kernel NULL pointer
dereference at (null)
Oct  1 12:49:56 x545 vmunix: IP: [<ffffffff810e6cb1>] put_page+0x1/0x40
Oct  1 12:49:56 x545 vmunix: PGD 129835067 PUD 12941b067 PMD 0
Oct  1 12:49:56 x545 vmunix: Oops: 0000 [#1] PREEMPT SMP
Oct  1 12:49:56 x545 vmunix: last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
Oct  1 12:49:56 x545 vmunix: CPU 0
Oct  1 12:49:56 x545 vmunix: Modules linked in: ipt_REJECT xt_recent
xt_state xt_tcpudp iptable_filter vboxnetadp vboxnetflt vboxdrv tipc
cpufreq_userspace cpufreq_conservative cpufreq_powersave cpufreq_stats
acpi_pad power_meter sbs sbshc battery container pci_slot video output
fan ac hed binfmt_misc uinput fuse microcode ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
ipv6 ext4 jbd2 crc16 sha256_generic sg coretemp eeprom it87 hwmon_vid
hwmon i2c_dev pciehp pci_hotplug cpufreq_ondemand acpi_cpufreq
freq_table mperf snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_bt87x snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event tuner_simple
tuner_types snd_seq ir_sony_decoder ir_jvc_decoder snd_timer
snd_seq_device tuner ir_rc6_decoder msp3400 ir_rc5_decoder 8250_pnp snd
joydev 8250 serial_core ir_nec_decoder psmouse nvidia(P) bttv
v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 i2c_algo_bit
videobuf_dma_sg rtc_cmo
Oct  1 12:49:56 x545 vmunix:  rtc
Oct  1 12:49:56 x545 vmunix: _core rtc_lib videobuf_core btcx_risc
ir_common ir_core tveeprom i2c_i801 pcspkr serio_raw evdev soundcore
processor i2c_core snd_page_alloc btrfs zlib_deflate crc32c libcrc32c
ext2 redboot mtd usb_storage usb_libusual usbhid hid uhci_hcd
firewire_ohci sundance ehci_hcd floppy ide_cd_mod mii thermal button
sky2 sd_mod crc_t10dif cdrom firewire_core crc_itu_t intel_agp usbcore
[last unloaded: scsi_wait_scan]
Oct  1 12:49:56 x545 vmunix:
Oct  1 12:49:56 x545 vmunix: Pid: 14900, comm: ftp Tainted: P
 2.6.35.7 #1 965P-DS4/
Oct  1 12:49:56 x545 vmunix: RIP: 0010:[<ffffffff810e6cb1>]
[<ffffffff810e6cb1>] put_page+0x1/0x40
Oct  1 12:49:56 x545 vmunix: RSP: 0018:ffff880037bdbb88  EFLAGS: 00010246=

Oct  1 12:49:56 x545 vmunix: RAX: 0000000000000000 RBX: 0000000000000001
RCX: 00000000ffffffff
Oct  1 12:49:56 x545 vmunix: RDX: ffff880126bc2e40 RSI: ffff880126bc2ddc
RDI: 0000000000000000
Oct  1 12:49:56 x545 vmunix: RBP: ffff880037bdbba8 R08: 00000000dd83ae22
R09: 0000000000000000
Oct  1 12:49:56 x545 vmunix: R10: ffff8800379c9680 R11: 0000000000000000
R12: ffff880125274200
Oct  1 12:49:56 x545 vmunix: R13: ffff8800379c9778 R14: ffff8800379c9bcc
R15: 0000000000000000
Oct  1 12:49:56 x545 vmunix: FS:  00007f84de19e720(0000)
GS:ffff880001c00000(0000) knlGS:0000000000000000
Oct  1 12:49:56 x545 vmunix: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Oct  1 12:49:56 x545 vmunix: CR2: 0000000000000000 CR3: 000000003682d000
CR4: 00000000000006f0
Oct  1 12:49:56 x545 vmunix: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Oct  1 12:49:56 x545 vmunix: DR3: 0000000000000000 DR6: 00000000ffff0ff0
DR7: 0000000000000400
Oct  1 12:49:56 x545 vmunix: Process ftp (pid: 14900, threadinfo
ffff880037bda000, task ffff8801285b1690)
Oct  1 12:49:56 x545 vmunix: Stack:
Oct  1 12:49:56 x545 vmunix:  ffff880037bdbba8 ffffffff813980eb
ffff880125274200 0000000000000558
Oct  1 12:49:56 x545 vmunix: <0> ffff880037bdbbc8 ffffffff81397b59
ffff880125274200 ffff880125274200
Oct  1 12:49:56 x545 vmunix: <0> ffff880037bdbca8 ffffffff813e5c80
ffff880037bdbfd8 ffffffffa0f35e80
Oct  1 12:49:56 x545 vmunix: Call Trace:
Oct  1 12:49:56 x545 vmunix:  [<ffffffff813980eb>] ?
skb_release_data+0x9b/0xc0
Oct  1 12:49:56 x545 vmunix:  [<ffffffff81397b59>] __kfree_skb+0x19/0xa0
Oct  1 12:49:56 x545 vmunix:  [<ffffffff813e5c80>] tcp_recvmsg+0xa20/0xbf=
0
Oct  1 12:49:56 x545 vmunix:  [<ffffffff81459e0e>] ?
common_interrupt+0xe/0x13
Oct  1 12:49:56 x545 vmunix:  [<ffffffff81406ded>] inet_recvmsg+0x7d/0xc0=

Oct  1 12:49:56 x545 vmunix:  [<ffffffff8138ecdb>] sock_aio_read+0x15b/0x=
170
Oct  1 12:49:56 x545 vmunix:  [<ffffffff811269d2>] do_sync_read+0xd2/0x11=
0
Oct  1 12:49:56 x545 vmunix:  [<ffffffff81459e0e>] ?
common_interrupt+0xe/0x13
Oct  1 12:49:56 x545 vmunix:  [<ffffffff81075ab9>] ? ktime_get_ts+0xa9/0x=
e0
Oct  1 12:49:56 x545 vmunix:  [<ffffffff81137e68>] ?
poll_select_copy_remaining+0xf8/0x140
Oct  1 12:49:56 x545 vmunix:  [<ffffffff811cdb51>] ?
security_file_permission+0x11/0x20
Oct  1 12:49:56 x545 vmunix:  [<ffffffff811271c7>] vfs_read+0x157/0x170
Oct  1 12:49:56 x545 vmunix:  [<ffffffff8112722c>] sys_read+0x4c/0x80
Oct  1 12:49:56 x545 vmunix:  [<ffffffff81002e6b>]
system_call_fastpath+0x16/0x1b
Oct  1 12:49:56 x545 vmunix: Code: 4c 89 ef e8 72 d0 00 00 4c 89 f6 4c
89 e7 e8 07 2c 37 00 e9 37 ff ff ff 66 90 0f ba 33 15 be 05 00 00 00 eb
db eb 03 90 90 90 55 <48> f7 07 00 c0 00 00 48 89 e5 75 1a f0 ff 4f 08
0f 94 c0 84 c0
Oct  1 12:49:56 x545 vmunix: RIP  [<ffffffff810e6cb1>] put_page+0x1/0x40
Oct  1 12:49:56 x545 vmunix:  RSP <ffff880037bdbb88>
Oct  1 12:49:56 x545 vmunix: CR2: 0000000000000000
Oct  1 12:49:56 x545 vmunix: ---[ end trace 99688ca8b8351598 ]---
Oct  1 12:50:55 x545 vmunix: BUG: unable to handle kernel NULL pointer
dereference at (null)
Oct  1 12:50:55 x545 vmunix: IP: [<ffffffff810e6cb1>] put_page+0x1/0x40
Oct  1 12:50:55 x545 vmunix: PGD 5b4ec067 PUD 5b4eb067 PMD 0
Oct  1 12:50:55 x545 vmunix: Oops: 0000 [#2] PREEMPT SMP
Oct  1 12:50:55 x545 vmunix: last sysfs file:
/sys/devices/platform/coretemp.1/temp1_label
Oct  1 12:50:55 x545 vmunix: CPU 0
Oct  1 12:50:55 x545 vmunix: Modules linked in: ipt_REJECT xt_recent
xt_state xt_tcpudp iptable_filter vboxnetadp vboxnetflt vboxdrv tipc
cpufreq_userspace cpufreq_conservative cpufreq_powersave cpufreq_stats
acpi_pad power_meter sbs sbshc battery container pci_slot vide
o output fan ac hed binfmt_misc uinput fuse microcode ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
ip_tables x_tables ipv6 ext4 jbd2 crc16 sha256_generic sg coretemp
eeprom it87 hwmon_vid hwmon i2c_dev pciehp pci_hotplug cpufreq_ondeman
d acpi_cpufreq freq_table mperf snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_bt87x snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
tuner_simple tuner_types snd_seq ir_sony_decoder ir_jvc_decoder s
nd_timer snd_seq_device tuner ir_rc6_decoder msp3400 ir_rc5_decoder
8250_pnp snd joydev 8250 serial_core ir_nec_decoder psmouse nvidia(P)
bttv v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 i2c_algo_bit
videobuf_dma_sg rtc_cmo
Oct  1 12:50:55 x545 vmunix:  rtc
Oct  1 12:50:55 x545 vmunix: _core rtc_lib videobuf_core btcx_risc
ir_common ir_core tveeprom i2c_i801 pcspkr serio_raw evdev soundcore
processor i2c_core snd_page_alloc btrfs zlib_deflate crc32c libcrc32c
ext2 redboot mtd usb_storage usb_libusual usbhid hid uhci_hcd fir
ewire_ohci sundance ehci_hcd floppy ide_cd_mod mii thermal button sky2
sd_mod crc_t10dif cdrom firewire_core crc_itu_t intel_agp usbcore [last
unloaded: scsi_wait_scan]
Oct  1 12:50:55 x545 vmunix:
Oct  1 12:50:55 x545 vmunix: Pid: 14977, comm: ftp Tainted: P      D
 2.6.35.7 #1 965P-DS4/
Oct  1 12:50:55 x545 vmunix: RIP: 0010:[<ffffffff810e6cb1>]
[<ffffffff810e6cb1>] put_page+0x1/0x40
Oct  1 12:50:55 x545 vmunix: RSP: 0018:ffff88005b5bdb88  EFLAGS: 00010246=

Oct  1 12:50:55 x545 vmunix: RAX: 0000000000000000 RBX: 0000000000000001
RCX: 00000000ffffffff
Oct  1 12:50:55 x545 vmunix: RDX: ffff88012a7b6640 RSI: ffff88012a7b65dc
RDI: 0000000000000000
Oct  1 12:50:55 x545 vmunix: RBP: ffff88005b5bdba8 R08: 0000000015e07096
R09: 0000000000000000
Oct  1 12:50:55 x545 vmunix: R10: ffff8800379c8780 R11: 0000000000000000
R12: ffff880037bb9900
Oct  1 12:50:55 x545 vmunix: R13: ffff8800379c8878 R14: ffff8800379c8ccc
R15: 0000000000000000
Oct  1 12:50:55 x545 vmunix: FS:  00007fb1ce0d1720(0000)
GS:ffff880001c00000(0000) knlGS:0000000000000000
Oct  1 12:50:55 x545 vmunix: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Oct  1 12:50:55 x545 vmunix: CR2: 0000000000000000 CR3: 000000005b4e9000
CR4: 00000000000006f0
Oct  1 12:50:55 x545 vmunix: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 00000000000

hdparm -i /dev/cdrom1
/dev/cdrom1:
SG_IO: questionable sense data, results may be incorrect

 Model=3DHL-DT-ST DVDRAM GSA-H42N, FwRev=3DRL00, SerialNo=3DK3B71******
 Config=3D{ Fixed Removeable DTR<=3D5Mbs DTR>10Mbs nonMagnetic }
 RawCHS=3D0/0/0, TrkSize=3D0, SectSize=3D0, ECCbytes=3D0
 BuffType=3Dunknown, BuffSize=3Dunknown, MaxMultSect=3D0
 (maybe): CurCHS=3D0/0/0, CurSects=3D0, LBA=3Dyes, LBAsects=3D0
 IORDY=3Don/off, tPIO=3D{min:120,w/IORDY:120}, tDMA=3D{min:120,rec:120}
 PIO modes:  pio0 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 *udma4
 AdvancedPM=3Dno
 Drive conforms to: unknown:  ATA/ATAPI-4,5,6,7

 * signifies the current active mode

lspci
00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub
(rev 02)


00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root Port
(rev 02)


00:03.0 Communication controller: Intel Corporation 82P965/G965 HECI
Controller (rev 02)


00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #4 (rev 02)


00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #5 (rev 02)


00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
Controller #2 (rev 02)


00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
Controller (rev 02)


00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 1 (rev 02)


00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 5 (rev 02)


00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 6 (rev 02)


00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #1 (rev 02)


00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #2 (rev 02)


00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #3 (rev 02)


00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
Controller #1 (rev 02)


00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)



00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface
Controller (rev 02)


00:1f.2 SATA controller: Intel Corporation 82801HR/HO/HH (ICH8R/DO/DH) 6
port SATA AHCI Controller (rev 02)


00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller
(rev 02)


01:00.0 VGA compatible controller: nVidia Corporation G71 [GeForce 7900
GT/GTO] (rev a1)


03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E
Gigabit Ethernet Controller (rev 22)


04:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial
ATA Controller (rev 02)


04:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA
Controller (rev 02)


05:00.0 Ethernet controller: D-Link System Inc DL10050 Sundance Ethernet



05:01.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)


05:01.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture
(rev 11)


05:06.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23
IEEE-1394a-2000 Controller (PHY/Link)

the mb interface:
04:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA
Controller (rev 02) (prog-if 85 [Master SecO PriO])
        Subsystem: Giga-byte Technology GA-EP45-DS5 Motherboard
        Flags: bus master, fast devsel, latency 0, IRQ 18
        I/O ports at 9000 [size=3D8]
        I/O ports at 9400 [size=3D4]
        I/O ports at 9800 [size=3D8]
        I/O ports at 9c00 [size=3D4]
        I/O ports at a000 [size=3D16]
        Capabilities: [68] Power Management version 2
        Kernel driver in use: JMicron IDE

- --=20
Sandro Weiser <Sandro.Weiser@gmx.de>
Fingerprint: 77E0 7C87 4DB2 6BBB 5419  343C 7995 1C67 25B9 CBF1
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREKAAYFAkyl7/cACgkQeZUcZyW5y/GqDQCeKfDdeda8LrEs4CYmhqICa4ZD
aGcAoI5sm4dVRPKQln0ZFdOKKmK3C8+H
=3DAIhm
-----END PGP SIGNATURE-----


--------------ms090808060206050404030908
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIU7zCC
BCEwggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBa
Fw0xOTA2MzAyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAw
DgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U
1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6
fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869
080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqD
oZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkh
nSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDov
L3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNy
bF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYDVR0OBBYEFEm3xs/oPR9/
6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB
/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IBAQA74Vp3wEgX
3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvhERHua3iR
M347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0Ja6ba
hWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyH
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIFSDCCBDCgAwIBAgIECdfudzAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTA3MDEyNTA4NTcxMloXDTE5MDExNTAwMDAwMFowgb0xCzAJBgNVBAYTAkRFMSkwJwYDVQQK
EyBUZWNobmlzY2hlIFVuaXZlcnNpdGFldCBDaGVtbml0ejEjMCEGA1UECxMaVW5pdmVyc2l0
YWV0c3JlY2hlbnplbnRydW0xPDA6BgNVBAMTM1RVIENoZW1uaXR6IENlcnRpZmljYXRpb24g
QXV0aG9yaXR5IC0gVFVDL1VSWiBDQSBHMzEgMB4GCSqGSIb3DQEJARYRY2FAdHUtY2hlbW5p
dHouZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCwu6P4RoCP2kbHqjFDJdHr
Pt/WUGh42n8kyaxdyxn+HaJrynixJEvLjoDsN3Q49+v+77Vdr7kOcFNTpkEF3QF8rN7GfM0B
ym64E7wppMMW06HBehKaq9EPEono+XVuJUmbyjdyS7RfXnuAqcraVUXx6YY9hXfk5E+JtWU9
du886W6VW1jG8uPHX0m5lYDK9y++bbu9M56F+HdK4THjcumjso0+3KGjUdADfGj4lKPoWYQq
Qqm+L7DbgyjrkcoEYsXFE9yeXcuSXf6LMBuaFzkx0+/Eta77N7UvEB5x/yNdsTpNCg8FY6Q5
zRdFHXXUNFIA9BZUtHZvtRGA90Q9EYVbAgMBAAGjggGwMIIBrDAPBgNVHRMBAf8EBTADAQH/
MAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQU6Nq48kfemSR9Z0CJJ2dxDWPYo44wHwYDVR0jBBgw
FoAUSbfGz+g9H3/qRHsTKffxCnA+3mQwHAYDVR0RBBUwE4ERY2FAdHUtY2hlbW5pdHouZGUw
gYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290
LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2ds
b2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGiBggrBgEFBQcBAQSBlTCBkjBHBggr
BgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2Fj
ZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xv
YmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQB7
gH9exRtN1ZZLVZLnd3oc9FB/1jT9vEVj/71JcvNmGsnjJlNKGGB5gmBBJvHmVR/BHihLAq15
MHE3OnTe6VCxKghC/etkL/AeSCJzPl45s1Gh8wtb9TRYTgiPxtMdyEJMNiL3w6KRR/c+5Bdd
psKERddeViNJL/S9M9JHLHV7t71FBSmnu7HI5ksEC5xDDGroiIrahBwQ5u8OAbFqpLKWFCCy
AVTpfQIjaf4klhLVBRis2YHZ60YsxWzmvUykBtEs0AzlyVy+P4rJwqSYdvxNPxonjkuWdVpm
WQoSpYJ0jzalZhoEKTra9Tov9i6kb7ezWKjQ1t6Rkr0a03uQ6qJ2MIIFuzCCBKOgAwIBAgIE
D+/WFDANBgkqhkiG9w0BAQUFADCBvTELMAkGA1UEBhMCREUxKTAnBgNVBAoTIFRlY2huaXNj
aGUgVW5pdmVyc2l0YWV0IENoZW1uaXR6MSMwIQYDVQQLExpVbml2ZXJzaXRhZXRzcmVjaGVu
emVudHJ1bTE8MDoGA1UEAxMzVFUgQ2hlbW5pdHogQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkg
LSBUVUMvVVJaIENBIEczMSAwHgYJKoZIhvcNAQkBFhFjYUB0dS1jaGVtbml0ei5kZTAeFw0x
MDA0MjIxNDA5MDlaFw0xMzA0MjExNDA5MDlaMF0xCzAJBgNVBAYTAkRFMSkwJwYDVQQKEyBU
ZWNobmlzY2hlIFVuaXZlcnNpdGFldCBDaGVtbml0ejELMAkGA1UECxMCSUYxFjAUBgNVBAMT
DVNhbmRybyBXZWlzZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDOPnlVhvuW
we7fDLRM18tyOIjtseXFydgkENjtFTy/x7juuryDl5E8nNc6EtjhJSD2smofWVieq5nD+9ZT
iNnZFUhwF6gkdSnu5HtDcPN7XUWWhWD0exzhquAMxAKsUopjgjRyBVTqlCgTf29ds44PsbRw
pbspGKBfXDfwzy83Aq67IhMkPVWw6yQgIORi/touqrJqYcEYXHVlTMC78cpEkpDT0CFOFCP4
2HUysT9Q+aHaGC120DHHDECzNDkUxVVCNW4fKv98jNd8HDMARUjLxiezXTGlV5EZfSFkwmxQ
eBfr8AIdWoE/v60tTLU5wfsczBOdP0RFlvwh2Ilw6ls/AgMBAAGjggIgMIICHDAJBgNVHRME
AjAAMAsGA1UdDwQEAwIF4DApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQB
gjcUAgIwHQYDVR0OBBYEFNWRJ5CohKeqY2CQiZfO1Co7zHjgMB8GA1UdIwQYMBaAFOjauPJH
3pkkfWdAiSdncQ1j2KOOMDIGA1UdEQQrMCmBJ3NhbmRyby53ZWlzZXJAaW5mb3JtYXRpay50
dS1jaGVtbml0ei5kZTCBiAYDVR0fBIGAMH4wPaA7oDmGN2h0dHA6Ly9jZHAxLnBjYS5kZm4u
ZGUvdHUtY2hlbW5pdHotY2EvcHViL2NybC9jYWNybC5jcmwwPaA7oDmGN2h0dHA6Ly9jZHAy
LnBjYS5kZm4uZGUvdHUtY2hlbW5pdHotY2EvcHViL2NybC9jYWNybC5jcmwwgdcGCCsGAQUF
BwEBBIHKMIHHMDMGCCsGAQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2Vy
dmVyL09DU1AwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdHUtY2hlbW5p
dHotY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEcGCCsGAQUFBzAChjtodHRwOi8vY2RwMi5w
Y2EuZGZuLmRlL3R1LWNoZW1uaXR6LWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDANBgkqhkiG
9w0BAQUFAAOCAQEAeuvms8KY5yTS2o8gQuZPc+QTrq2UFURbOiQ1sOeBOUDFeL0ChMUzCIq1
Oaa/Vagci6ohj3F5NahBfVdxpBpE3YNtQFaRZDaS2R77TfHfd78ZTsqW/0LX9cNy7dcDQa/M
GOhgMTayFkJLzVP9D57j8InT0bhDlXIqJuG481C9im4sojuyPBg0Tv9tTumjlLh3fVseHYAg
HY21h1gsYt7oL7JKUjcjbO7LpYwxRGCI1qHG1vf5IxhkEOkVnDwAaU3mdxlj7tHSKZbIe+kf
eBoRmP8HDceNmsIuBsOJB1dFPz+RBGRO4qmzVO6kECeqfJzL3V0Qx0LSIutbeIPIQiYRlTCC
BbswggSjoAMCAQICBA/v1hQwDQYJKoZIhvcNAQEFBQAwgb0xCzAJBgNVBAYTAkRFMSkwJwYD
VQQKEyBUZWNobmlzY2hlIFVuaXZlcnNpdGFldCBDaGVtbml0ejEjMCEGA1UECxMaVW5pdmVy
c2l0YWV0c3JlY2hlbnplbnRydW0xPDA6BgNVBAMTM1RVIENoZW1uaXR6IENlcnRpZmljYXRp
b24gQXV0aG9yaXR5IC0gVFVDL1VSWiBDQSBHMzEgMB4GCSqGSIb3DQEJARYRY2FAdHUtY2hl
bW5pdHouZGUwHhcNMTAwNDIyMTQwOTA5WhcNMTMwNDIxMTQwOTA5WjBdMQswCQYDVQQGEwJE
RTEpMCcGA1UEChMgVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgQ2hlbW5pdHoxCzAJBgNVBAsT
AklGMRYwFAYDVQQDEw1TYW5kcm8gV2Vpc2VyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAzj55VYb7lsHu3wy0TNfLcjiI7bHlxcnYJBDY7RU8v8e47rq8g5eRPJzXOhLY4SUg
9rJqH1lYnquZw/vWU4jZ2RVIcBeoJHUp7uR7Q3Dze11FloVg9Hsc4argDMQCrFKKY4I0cgVU
6pQoE39vXbOOD7G0cKW7KRigX1w38M8vNwKuuyITJD1VsOskICDkYv7aLqqyamHBGFx1ZUzA
u/HKRJKQ09AhThQj+Nh1MrE/UPmh2hgtdtAxxwxAszQ5FMVVQjVuHyr/fIzXfBwzAEVIy8Yn
s10xpVeRGX0hZMJsUHgX6/ACHVqBP7+tLUy1OcH7HMwTnT9ERZb8IdiJcOpbPwIDAQABo4IC
IDCCAhwwCQYDVR0TBAIwADALBgNVHQ8EBAMCBeAwKQYDVR0lBCIwIAYIKwYBBQUHAwIGCCsG
AQUFBwMEBgorBgEEAYI3FAICMB0GA1UdDgQWBBTVkSeQqISnqmNgkImXztQqO8x44DAfBgNV
HSMEGDAWgBTo2rjyR96ZJH1nQIknZ3ENY9ijjjAyBgNVHREEKzApgSdzYW5kcm8ud2Vpc2Vy
QGluZm9ybWF0aWsudHUtY2hlbW5pdHouZGUwgYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8v
Y2RwMS5wY2EuZGZuLmRlL3R1LWNoZW1uaXR6LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5
hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWNoZW1uaXR6LWNhL3B1Yi9jcmwvY2Fjcmwu
Y3JsMIHXBggrBgEFBQcBAQSByjCBxzAzBggrBgEFBQcwAYYnaHR0cDovL29jc3AucGNhLmRm
bi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEcGCCsGAQUFBzAChjtodHRwOi8vY2RwMS5wY2EuZGZu
LmRlL3R1LWNoZW1uaXR6LWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDBHBggrBgEFBQcwAoY7
aHR0cDovL2NkcDIucGNhLmRmbi5kZS90dS1jaGVtbml0ei1jYS9wdWIvY2FjZXJ0L2NhY2Vy
dC5jcnQwDQYJKoZIhvcNAQEFBQADggEBAHrr5rPCmOck0tqPIELmT3PkE66tlBVEWzokNbDn
gTlAxXi9AoTFMwiKtTmmv1WoHIuqIY9xeTWoQX1XcaQaRN2DbUBWkWQ2ktke+03x33e/GU7K
lv9C1/XDcu3XA0GvzBjoYDE2shZCS81T/Q+e4/CJ09G4Q5VyKibhuPNQvYpuLKI7sjwYNE7/
bU7po5S4d31bHh2AIB2NtYdYLGLe6C+ySlI3I2zuy6WMMURgiNahxtb3+SMYZBDpFZw8AGlN
5ncZY+7R0imWyHvpH3gaEZj/Bw3HjZrCLgbDiQdXRT8/kQRkTuKps1TupBAnqnycy91dEMdC
0iLrW3iDyEImEZUxggRmMIIEYgIBATCBxjCBvTELMAkGA1UEBhMCREUxKTAnBgNVBAoTIFRl
Y2huaXNjaGUgVW5pdmVyc2l0YWV0IENoZW1uaXR6MSMwIQYDVQQLExpVbml2ZXJzaXRhZXRz
cmVjaGVuemVudHJ1bTE8MDoGA1UEAxMzVFUgQ2hlbW5pdHogQ2VydGlmaWNhdGlvbiBBdXRo
b3JpdHkgLSBUVUMvVVJaIENBIEczMSAwHgYJKoZIhvcNAQkBFhFjYUB0dS1jaGVtbml0ei5k
ZQIED+/WFDAJBgUrDgMCGgUAoIICdDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
SIb3DQEJBTEPFw0xMDEwMDExNDI4MjVaMCMGCSqGSIb3DQEJBDEWBBTvIIvICKjZ62NTf6dn
3hvArtOggzBfBgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggq
hkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgdcG
CSsGAQQBgjcQBDGByTCBxjCBvTELMAkGA1UEBhMCREUxKTAnBgNVBAoTIFRlY2huaXNjaGUg
VW5pdmVyc2l0YWV0IENoZW1uaXR6MSMwIQYDVQQLExpVbml2ZXJzaXRhZXRzcmVjaGVuemVu
dHJ1bTE8MDoGA1UEAxMzVFUgQ2hlbW5pdHogQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgLSBU
VUMvVVJaIENBIEczMSAwHgYJKoZIhvcNAQkBFhFjYUB0dS1jaGVtbml0ei5kZQIED+/WFDCB
2QYLKoZIhvcNAQkQAgsxgcmggcYwgb0xCzAJBgNVBAYTAkRFMSkwJwYDVQQKEyBUZWNobmlz
Y2hlIFVuaXZlcnNpdGFldCBDaGVtbml0ejEjMCEGA1UECxMaVW5pdmVyc2l0YWV0c3JlY2hl
bnplbnRydW0xPDA6BgNVBAMTM1RVIENoZW1uaXR6IENlcnRpZmljYXRpb24gQXV0aG9yaXR5
IC0gVFVDL1VSWiBDQSBHMzEgMB4GCSqGSIb3DQEJARYRY2FAdHUtY2hlbW5pdHouZGUCBA/v
1hQwDQYJKoZIhvcNAQEBBQAEggEAFIbKPzQ6DXCdg4nOM7HlvRKopUOljmLIpc1ujgbMG54Q
+UhTfk+ffIds036Kz/271DOxquVX34UX77UCRMVcZbQgagCN+leYfcLExsvOxTyum8LVzXwY
EIY+2ikdI/y7eAs2mUZeAuZB0QkZhdsXURn5gF4dpZr4AmpsJnncVoBXNhba48l690ce/NpT
mK5Z2cThrwUgniPSMVdBcUhZmMrNbs2vYSz5pnuyZS12/yRNJfYvl96hOtzq4eOz+LrW4qBn
H4cgkH+xozFWIl4PtelIPEyFEqoG5bYoBvmQ5yRBKFmDE8lZu0695dUaW7mvptD71oWgGcL/
22/+ca0drAAAAAAAAA==
--------------ms090808060206050404030908--
