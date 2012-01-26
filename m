Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2AZQbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:31:40 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:60656 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051Ab2AZQbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:31:38 -0500
Date: Thu, 26 Jan 2012 18:31:32 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Yves-Alexis Perez <corsac@debian.org>, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-usb@vger.kernel.org
Subject: Re: [3.2+] BUG: scheduling while atomic: swapper/0/0/0x10000100
Message-ID: <20120126163130.GB8665@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1327587732.2296.25.camel@scapa>
 <20120126161539.GA2098@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <20120126161539.GA2098@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 26, 2012 at 08:15:39AM -0800, Greg KH wrote:
> On Thu, Jan 26, 2012 at 03:22:12PM +0100, Yves-Alexis Perez wrote:
> > Hi,
> >=20
> > I have an issue starting with 3.2 kernel on my Thinkpad x201s. I've
> > reported a bug on kernel bugzilla
> > (https://bugzilla.kernel.org/show_bug.cgi?id=3D42615) but I'm not too s=
ure
> > anyone reads it so I'm re-reporting it here. It looks like the same bug
> > as https://bugs.launchpad.net/linux/+bug/917962.
> >=20
> > Basically everything is explained in both bugs, but here's a summary.
> > When I first upgraded to the 3.2 linux-image package (the system runs
> > Debian sid amd64), few seconds after the boot is complete I got the
> > following BUG():
> >=20
> > Jan 20 11:27:53 scapa kernel: [   63.904544] BUG: scheduling while atom=
ic: swapper/0/0/0x10000100
> > Jan 20 11:27:53 scapa kernel: [   63.904550] Modules linked in: bnep rf=
comm bluetooth deflate zlib_deflate ctr twofish_generic twofish_x86_64_3way=
 twofish_x86_64 twofish_common camellia serpent blowfish_generic blowfish_x=
86_64 blowfish_common nf_conntrack_ipv6 nf_defrag_ipv6 cast5 ip6table_filte=
r ip6_tables des_generic nf_conntrack_ipv4 cbc nf_defrag_ipv4 xt_state xcbc=
 nf_conntrack rmd160 iptable_filter ip_tables x_tables sha512_generic sha25=
6_generic sha1_ssse3 sha1_generic hmac crypto_null af_key ums_realtek usb_s=
torage uas ext2 acpi_cpufreq mperf snd_hda_codec_hdmi snd_hda_codec_conexan=
t arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss iwlw=
ifi snd_pcm mac80211 snd_timer cfg80211 ehci_hcd thinkpad_acpi usbcore e100=
0e snd psmouse iTCO_wdt soundcore pcspkr rfkill i2c_i801 iTCO_vendor_suppor=
t snd_page_alloc intel_ips serio_raw ac usb_common nvram battery tpm_tis po=
wer_supply tpm tpm_bios wmi evdev processor ext4 mbcache jbd2 crc16 xts gf1=
28mul dm_crypt d!
>  m_mod aesni_intel cryptd aes_x86_64 aes
> > Jan 20 11:27:53 scapa kernel: _generic sd_mod crc_t10dif ahci libahci i=
915 thermal drm_kms_helper libata scsi_mod drm i2c_algo_bit button i2c_core=
 video thermal_sys
> > Jan 20 11:27:53 scapa kernel: [   63.904669] CPU 0=20
> > Jan 20 11:27:53 scapa kernel: [   63.904671] Modules linked in: bnep rf=
comm bluetooth deflate zlib_deflate ctr twofish_generic twofish_x86_64_3way=
 twofish_x86_64 twofish_common camellia serpent blowfish_generic blowfish_x=
86_64 blowfish_common nf_conntrack_ipv6 nf_defrag_ipv6 cast5 ip6table_filte=
r ip6_tables des_generic nf_conntrack_ipv4 cbc nf_defrag_ipv4 xt_state xcbc=
 nf_conntrack rmd160 iptable_filter ip_tables x_tables sha512_generic sha25=
6_generic sha1_ssse3 sha1_generic hmac crypto_null af_key ums_realtek usb_s=
torage uas ext2 acpi_cpufreq mperf snd_hda_codec_hdmi snd_hda_codec_conexan=
t arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss iwlw=
ifi snd_pcm mac80211 snd_timer cfg80211 ehci_hcd thinkpad_acpi usbcore e100=
0e snd psmouse iTCO_wdt soundcore pcspkr rfkill i2c_i801 iTCO_vendor_suppor=
t snd_page_alloc intel_ips serio_raw ac usb_common nvram battery tpm_tis po=
wer_supply tpm tpm_bios wmi evdev processor ext4 mbcache jbd2 crc16 xts gf1=
28mul dm_crypt d!
>  m_mod aesni_intel cryptd aes_x86_64 aes
> > Jan 20 11:27:53 scapa kernel: _generic sd_mod crc_t10dif ahci libahci i=
915 thermal drm_kms_helper libata scsi_mod drm i2c_algo_bit button i2c_core=
 video thermal_sys
> > Jan 20 11:27:53 scapa kernel: [   63.904752]=20
> > Jan 20 11:27:53 scapa kernel: [   63.904756] Pid: 0, comm: swapper/0 No=
t tainted 3.2.0-1-amd64 #1 LENOVO 51434JG/51434JG
> > Jan 20 11:27:53 scapa kernel: [   63.904761] RIP: 0010:[<ffffffff811e36=
f5>]  [<ffffffff811e36f5>] intel_idle+0xea/0x119
> > Jan 20 11:27:53 scapa kernel: [   63.904773] RSP: 0018:ffffffff81601e88=
  EFLAGS: 00000202
> > Jan 20 11:27:53 scapa kernel: [   63.904776] RAX: 0000000000000000 RBX:=
 ffffffff81023b30 RCX: 0000000000007fda
> > Jan 20 11:27:53 scapa kernel: [   63.904779] RDX: 0000000000007fda RSI:=
 0000000000000000 RDI: 00000000000003e8
> > Jan 20 11:27:53 scapa kernel: [   63.904782] RBP: 0000000000000003 R08:=
 0000000000007fa9 R09: 0000000000007fa9
> > Jan 20 11:27:53 scapa kernel: [   63.904785] R10: 0000000000001311 R11:=
 ffffffff8160d020 R12: ffffffff81065de9
> > Jan 20 11:27:53 scapa kernel: [   63.904788] R13: 000000000000003f R14:=
 ffffffff810659e7 R15: ffffffff8101357e
> > Jan 20 11:27:53 scapa kernel: [   63.904792] FS:  0000000000000000(0000=
) GS:ffff880137c00000(0000) knlGS:0000000000000000
> > Jan 20 11:27:53 scapa kernel: [   63.904796] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
> > Jan 20 11:27:53 scapa kernel: [   63.904799] CR2: 00007fc217631aa1 CR3:=
 0000000001605000 CR4: 00000000000006f0
> > Jan 20 11:27:53 scapa kernel: [   63.904802] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
> > Jan 20 11:27:53 scapa kernel: [   63.904805] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
> > Jan 20 11:27:53 scapa kernel: [   63.904809] Process swapper/0 (pid: 0,=
 threadinfo ffffffff81600000, task ffffffff8160d020)
> > Jan 20 11:27:53 scapa kernel: [   63.904811] Stack:
> > Jan 20 11:27:53 scapa kernel: [   63.904813]  0000000000000000 00000000=
00007fda 0000000000000000 0000000000000000
> > Jan 20 11:27:53 scapa kernel: [   63.904819]  0000000000007fda 00000000=
01f2ae3a ffff880137c19970 ffffffff81645680
> > Jan 20 11:27:53 scapa kernel: [   63.904824]  00000000fffffff0 00000000=
00000003 ffffffff81645778 ffffffff812633c3
> > Jan 20 11:27:53 scapa kernel: [   63.904829] Call Trace:
> > Jan 20 11:27:53 scapa kernel: [   63.904839]  [<ffffffff812633c3>] ? cp=
uidle_idle_call+0xec/0x179
> > Jan 20 11:27:53 scapa kernel: [   63.904846]  [<ffffffff8100d255>] ? cp=
u_idle+0xa1/0xe8
> > Jan 20 11:27:53 scapa kernel: [   63.904852]  [<ffffffff816a9b3d>] ? st=
art_kernel+0x3bd/0x3c8
> > Jan 20 11:27:53 scapa kernel: [   63.904857]  [<ffffffff816a9140>] ? ea=
rly_idt_handlers+0x140/0x140
> > Jan 20 11:27:53 scapa kernel: [   63.904861]  [<ffffffff816a93c4>] ? x8=
6_64_start_kernel+0x104/0x111
> > Jan 20 11:27:53 scapa kernel: [   63.904864] Code: 29 f0 48 89 c7 e8 77=
 77 e6 ff 4c 69 e8 40 42 0f 00 48 89 04 24 48 89 54 24 08 48 89 44 24 18 48=
 89 54 24 20 49 01 d5 fb 66 66 90 <66> 66 90 85 1d ea 21 46 00 75 0f 48 8d =
74 24 2c bf 05 00 00 00=20
> > Jan 20 11:27:53 scapa kernel: [   63.904905] Call Trace:
> > Jan 20 11:27:53 scapa kernel: [   63.904910]  [<ffffffff812633c3>] ? cp=
uidle_idle_call+0xec/0x179
> > Jan 20 11:27:53 scapa kernel: [   63.904914]  [<ffffffff8100d255>] ? cp=
u_idle+0xa1/0xe8
> > Jan 20 11:27:53 scapa kernel: [   63.904918]  [<ffffffff816a9b3d>] ? st=
art_kernel+0x3bd/0x3c8
> > Jan 20 11:27:53 scapa kernel: [   63.904922]  [<ffffffff816a9140>] ? ea=
rly_idt_handlers+0x140/0x140
> > Jan 20 11:27:53 scapa kernel: [   63.904926]  [<ffffffff816a93c4>] ? x8=
6_64_start_kernel+0x104/0x111
> >=20
> > I successfully reproduced using vanilla kernel, so I started bisecting.
> > I did two bisect rounds (complete log on the bug reports) and found the
> > first bad commit to be:
> >=20
> > a2c76b83fdd763c826f38a55127ccf25708099ce is the first bad commit
> > commit a2c76b83fdd763c826f38a55127ccf25708099ce
> > Author: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > Date: Tue Oct 18 20:05:50 2011 -0700
> >=20
> >     usb: renesas_usbhs: fixup inconsistent return from usbhs_pkt_push()
> >=20
> >     usbhs_pkt_push() had inconsistent return under spin lock.
> >     This patch fix it up.
> >     Special thanks to Dan
> >=20
> >     Cc: Dan Carpenter <dan.carpenter@oracle.com>
> >     Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >=20
> > :040000 040000 08d80fa06121151b36ae17dc693c14d58c0d5db3
> > 86b920618ceb575cebf610798c24a104dea36a2c M    drivers
> >=20
> > Reverting this commit on top of 3.2.1 removes the BUG().
>=20
> Very odd, it wouldn't seem that this patch would cause such a problem,
> as it is "obviously" correct.

The funny thing is that I don't think there's any x86 system out there
with this *DRD* controller :-) Specially when you consider the fact that
it's very recently that we dropped the ARCH dependency with commit
d242c110c43b55aaf3ebb3ceac1eeab0d452a177

> Kuninori, any thoughts about this?  Should I revert this from the
> tree?

I don't think so, I think this was a bad bisection.

--=20
balbi

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIX/hAAoJEIaOsuA1yqREofMP/jLqKV8H1UA3jT3Z081+Ules
2D9doHFbswq7hYUwEMIJP/tp7FPAfksrES+MTl/m2EbkAVCsa47d9Oj+4EWlZwlh
IpUrRsbirYsXxdiga97G3sj6XIerZ+KmkCubtloWy4BpXuune65G6Y4Zn7RPVi3/
nklvjrBwQ1mZb9CprDSB2upaPKJrkA28NTdj7Mw8csXYX0DYgiycbv26KJGcNuMt
tgx1LxkujyppPI40kpvz1fvuVeYBsuXOG3gLClngkRh1TRpSr8iB5JMwCK5Ue4iV
dQ3nQyewbp2AprkWyyyuwww3DzPLdd7EpolXsDBJPaFKM75oHdUaYno5acdcYAwC
2syYfr7czE1/StXbHsGkaxnddpASrAUeEdBoiGkhmSh1VAonwg+GyWJTi0/6I/F7
xBQKx9U2eruDJVmygdo5LA7MksUcVwSRfaWQHoz9WAR0CGMyQxmUyTSVnnMXsYxq
tG4h3aWHx6c1vjV7RYD4ntUROzlK/4e57aHqvgsTqM8KJHiXtlhruXW7xataSyBV
WbxIPOrbPVZObZlDQF9HRrBTquAP4WjZJaVUyWFvCtiqBGP6Eoc5qdexG+6V5omQ
8gU4UyMGl+LC/WVw2CPjQHkuMvRYwF1yzixQGgzXze9k8Ifa0HncGdVH9uOPf/Bq
b7sjD/0lmwWvnI0tryCQ
=dQPe
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
