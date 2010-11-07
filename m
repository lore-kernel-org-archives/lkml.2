Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0KGMOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 07:14:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:44459 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752325Ab0KGMOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 07:14:45 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19q1wZD7jdqY7TQYrAoOgarA0Ff4AvxvILC+5JuwI
	QNjHRRxNIxCvNk
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Oops w/ 'Terratec Cinergy T USB XXS (HD)/ T3'
Date: Sun, 7 Nov 2010 13:14:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.4.5; i686; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_xgp1MW1EaYKT9dD"
Message-Id: <201011071314.41970.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_xgp1MW1EaYKT9dD
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I get with the current -git tree the attached OOps at an almost stable Gent=
oo=20
Linux running at a ThinkPad T400.

=2D-=20
MfG/Kind regards
Toralf F=C3=B6rster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


--Boundary-00=_xgp1MW1EaYKT9dD
Content-Type: text/plain;
  charset="UTF-8";
  name="Oops"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Oops"

2010-11-07T12:27:11.872+01:00 n22 kernel: usb 6-1: new high speed USB devic=
e using ehci_hcd and address 7
2010-11-07T12:27:11.987+01:00 n22 kernel: usb 6-1: New USB device found, id=
Vendor=3D0ccd, idProduct=3D00ab
2010-11-07T12:27:11.987+01:00 n22 kernel: usb 6-1: New USB device strings: =
Mfr=3D1, Product=3D2, SerialNumber=3D3
2010-11-07T12:27:11.987+01:00 n22 kernel: usb 6-1: Product: Cinergy T XXS
2010-11-07T12:27:11.987+01:00 n22 kernel: usb 6-1: Manufacturer: TerraTec G=
mbH
2010-11-07T12:27:11.987+01:00 n22 kernel: usb 6-1: SerialNumber: 0000000001
2010-11-07T12:27:12.066+01:00 n22 kernel: IR NEC protocol handler initializ=
ed
2010-11-07T12:27:12.204+01:00 n22 kernel: IR RC5(x) protocol handler initia=
lized
2010-11-07T12:27:12.206+01:00 n22 kernel: dib0700: loaded with support for =
15 different device-types
2010-11-07T12:27:12.206+01:00 n22 kernel: dvb-usb: found a 'Terratec Cinerg=
y T USB XXS (HD)/ T3' in cold state, will try to load a firmware
2010-11-07T12:27:12.212+01:00 n22 kernel: IR RC6 protocol handler initializ=
ed
2010-11-07T12:27:12.243+01:00 n22 kernel: dvb-usb: downloading firmware fro=
m file 'dvb-usb-dib0700-1.20.fw'
2010-11-07T12:27:12.260+01:00 n22 kernel: IR JVC protocol handler initializ=
ed
2010-11-07T12:27:12.277+01:00 n22 kernel: IR Sony protocol handler initiali=
zed
2010-11-07T12:27:12.292+01:00 n22 kernel: lirc_dev: IR Remote Control drive=
r registered, major 253=20
2010-11-07T12:27:12.298+01:00 n22 kernel: IR LIRC bridge handler initialized
2010-11-07T12:27:12.449+01:00 n22 kernel: dib0700: firmware started success=
fully.
2010-11-07T12:27:12.950+01:00 n22 kernel: dvb-usb: found a 'Terratec Cinerg=
y T USB XXS (HD)/ T3' in warm state.
2010-11-07T12:27:12.961+01:00 n22 kernel: dvb-usb: will pass the complete M=
PEG2 transport stream to the software demuxer.
2010-11-07T12:27:12.961+01:00 n22 kernel: DVB: registering new adapter (Ter=
ratec Cinergy T USB XXS (HD)/ T3)
2010-11-07T12:27:13.178+01:00 n22 kernel: DVB: registering adapter 0 fronte=
nd 0 (DiBcom 7000PC)...
2010-11-07T12:27:13.740+01:00 n22 kernel: BUG: unable to handle kernel NULL=
 pointer dereference at   (null)
2010-11-07T12:27:13.740+01:00 n22 kernel: IP: [<f82625a9>] i2c_transfer+0x1=
9/0xb0 [i2c_core]
2010-11-07T12:27:13.740+01:00 n22 kernel: *pde =3D 00000000=20
2010-11-07T12:27:13.740+01:00 n22 kernel: Oops: 0000 [#1] SMP=20
2010-11-07T12:27:13.740+01:00 n22 kernel: last sysfs file: /sys/devices/pci=
0000:00/0000:00:1a.7/usb6/6-1/firmware/6-1/loading
2010-11-07T12:27:13.740+01:00 n22 kernel: Modules linked in: ir_lirc_codec =
lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder dvb_usb_dib0700(+) i=
r_rc5_decoder dib7000p dib0090 dib7000m dib0070 dvb_usb dib8000 dvb_core di=
b3000mc dibx000_common ir_nec_decoder ir_core ipt_MASQUERADE ipt_REJECT xt_=
recent xt_tcpudp nf_conntrack_ftp xt_state xt_limit ipt_LOG iptable_nat nf_=
nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_owner x=
t_multiport ip_tables x_tables pppoe pppox ppp_generic slhc af_packet fuse =
fbcon font bitblit softcursor acpi_cpufreq mperf dm_mod arc4 ecb crypto_blk=
cipher hid_cherry snd_hda_codec_conexant cryptomgr aead crypto_algapi i915 =
usbhid hid usblp drm_kms_helper snd_hda_intel drm iwlagn thinkpad_acpi snd_=
hda_codec snd_pcm iwlcore fb hwmon snd_timer fbdev ehci_hcd uhci_hcd mac802=
11 snd usbcore cfg80211 intel_agp i2c_algo_bit 8250_pci cfbcopyarea sr_mod =
soundcore intel_gtt i2c_i801 e1000e cdrom 8250_pnp led_class snd_page_alloc=
 rfkill agpgart i2c_core nvram battery evdev video wmi ac processor 8250 cf=
bimgblt cfbfillrect psmouse serial_core output thermal nls_base button
2010-11-07T12:27:13.740+01:00 n22 kernel:=20
2010-11-07T12:27:13.740+01:00 n22 kernel: Pid: 10780, comm: modprobe Not ta=
inted 2.6.37-rc1+ #4 6474B84/6474B84
2010-11-07T12:27:13.740+01:00 n22 kernel: EIP: 0060:[<f82625a9>] EFLAGS: 00=
010296 CPU: 0
2010-11-07T12:27:13.740+01:00 n22 kernel: EIP is at i2c_transfer+0x19/0xb0 =
[i2c_core]
2010-11-07T12:27:13.747+01:00 n22 kernel: EAX: 00000000 EBX: ffffffa1 ECX: =
00000002 EDX: f486dd40
2010-11-07T12:27:13.747+01:00 n22 kernel: ESI: f49bdaf8 EDI: f49bdaf8 EBP: =
f486dd30 ESP: f486dd18
2010-11-07T12:27:13.747+01:00 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00=
e0 SS: 0068
2010-11-07T12:27:13.747+01:00 n22 kernel: Process modprobe (pid: 10780, ti=
=3Df486c000 task=3Df5255830 task.ti=3Df486c000)
2010-11-07T12:27:13.747+01:00 n22 kernel: Stack:
2010-11-07T12:27:13.747+01:00 n22 kernel: c103f5c0 00000002 f486dd40 fa46c8=
e0 f49bdaf8 f49bdaf8 f486dd5c fa40e13a
2010-11-07T12:27:13.747+01:00 n22 kernel: ffffffff 3a026e22 00000060 f49b00=
01 f486dd3c 00010060 c1250002 f486dd5a
2010-11-07T12:27:13.747+01:00 n22 kernel: c103f9a5 f486dd8c fa40ed82 fa40f6=
20 00000000 fa40f360 f49bd800 f49aa000
2010-11-07T12:27:13.747+01:00 n22 kernel: Call Trace:
2010-11-07T12:27:13.747+01:00 n22 kernel: [<c103f5c0>] ? process_timeout+0x=
0/0x10
2010-11-07T12:27:13.747+01:00 n22 kernel: [<fa40e13a>] ? dib0070_read_reg+0=
x4a/0x70 [dib0070]
2010-11-07T12:27:13.747+01:00 n22 kernel: [<c1250002>] ? mcheck_cpu_init+0x=
2b9/0x2ca
2010-11-07T12:27:13.747+01:00 n22 kernel: [<c103f9a5>] ? msleep+0x15/0x20
2010-11-07T12:27:13.747+01:00 n22 kernel: [<fa40ed82>] ? dib0070_attach+0x9=
2/0x450 [dib0070]
2010-11-07T12:27:13.747+01:00 n22 kernel: [<fa40ecf0>] ? dib0070_attach+0x0=
/0x450 [dib0070]
2010-11-07T12:27:13.747+01:00 n22 kernel: [<fa462f7d>] ? dib7770p_tuner_att=
ach+0x4d/0xe0 [dvb_usb_dib0700]
2010-11-07T12:27:13.747+01:00 n22 kernel: [<fa3fff15>] ? dvb_usb_adapter_fr=
ontend_init+0x75/0xf0 [dvb_usb]
2010-11-07T12:27:13.747+01:00 n22 kernel: [<fa3ff858>] ? dvb_usb_device_ini=
t+0x328/0x5e0 [dvb_usb]
2010-11-07T12:27:13.747+01:00 n22 kernel: [<fa461a89>] ? dib0700_probe+0x59=
/0xd0 [dvb_usb_dib0700]
2010-11-07T12:27:13.747+01:00 n22 kernel: [<f8289d4a>] ? usb_probe_interfac=
e+0xca/0x1d0 [usbcore]
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c10f1472>] ? sysfs_create_link+=
0x12/0x20
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c119b4e7>] ? driver_probe_devic=
e+0x77/0x1a0
2010-11-07T12:27:13.748+01:00 n22 kernel: [<f8288b71>] ? usb_match_id+0x41/=
0x60 [usbcore]
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c119b6a1>] ? __driver_attach+0x=
91/0xa0
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c119ad98>] ? bus_for_each_dev+0=
x48/0x70
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c119b369>] ? driver_attach+0x19=
/0x20
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c119b610>] ? __driver_attach+0x=
0/0xa0
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c119a787>] ? bus_add_driver+0x1=
77/0x240
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c119b935>] ? driver_register+0x=
65/0x120
2010-11-07T12:27:13.748+01:00 n22 kernel: [<f8289a5c>] ? usb_register_drive=
r+0x7c/0x140 [usbcore]
2010-11-07T12:27:13.748+01:00 n22 kernel: [<fa470030>] ? dib0700_module_ini=
t+0x30/0x4d [dvb_usb_dib0700]
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c1001130>] ? do_one_initcall+0x=
30/0x160
2010-11-07T12:27:13.748+01:00 n22 kernel: [<fa470000>] ? dib0700_module_ini=
t+0x0/0x4d [dvb_usb_dib0700]
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c1063d39>] ? sys_init_module+0x=
99/0x1e0
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c10a8f7d>] ? sys_read+0x3d/0x70
2010-11-07T12:27:13.748+01:00 n22 kernel: [<c1002e97>] ? sysenter_do_call+0=
x12/0x26
2010-11-07T12:27:13.748+01:00 n22 kernel: Code: 66 90 c3 eb 0d 90 90 90 90 =
90 90 90 90 90 90 90 90 90 55 89 e5 57 56 89 c6 53 bb a1 ff ff ff 83 ec 0c =
89 55 f0 89 4d ec 8b 40 0c <8b> 10 85 d2 74 6a 89 e0 25 00 e0 ff ff f7 40 1=
4 ff ff ff ef 75=20
2010-11-07T12:27:13.748+01:00 n22 kernel: EIP: [<f82625a9>] i2c_transfer+0x=
19/0xb0 [i2c_core] SS:ESP 0068:f486dd18
2010-11-07T12:27:13.748+01:00 n22 kernel: CR2: 0000000000000000
2010-11-07T12:27:13.748+01:00 n22 kernel: ---[ end trace 47926147ea482522 ]=
=2D--
2010-11-07T12:27:21.552+01:00 n22 kernel: usb 6-1: USB disconnect, address 7

--Boundary-00=_xgp1MW1EaYKT9dD--
