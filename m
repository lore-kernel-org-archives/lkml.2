Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1I2ObG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:31:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37624 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1I2ObE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:31:04 -0400
Date: Thu, 29 Sep 2011 09:30:58 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Luciano Coelho <coelho@ti.com>
Cc: ecryptfs@vger.kernel.org, kirkland@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: Oops in ecryptfs (apparently) with 3.1-rc6
Message-ID: <20110929143058.GA15933@boyd>
References: <1316781869.4051.7.camel@cumari>
 <1317235816.2171.158.camel@cumari>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1317235816.2171.158.camel@cumari>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2011-09-28 21:50:15, Luciano Coelho wrote:
> On Fri, 2011-09-23 at 15:44 +0300, Luciano Coelho wrote:=20
> > I just got this oops on my PC, while running 3.1-rc6 normally:
> >=20
> > [255264.517298] Oops: 0000 [#1] SMP=20
> > [255264.517301] CPU 4=20
> > [255264.517303] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat dm_=
crypt pl2303 ftdi_sio usbserial cryptd aes_x86_64 aes_generic binfmt_misc s=
nd_hda_codec_analog nvidia(P) snd_hda_intel snd_hda_codec snd_hwdep snd_pcm=
 snd_seq_midi psmouse snd_rawmidi snd_seq_midi_event snd_seq snd_timer dell=
_wmi nfsd exportfs snd_seq_device serio_raw nfs sparse_keymap snd soundcore=
 snd_page_alloc i7core_edac edac_core ppdev lp dcdbas lockd fscache auth_rp=
cgss nfs_acl sunrpc parport_pc parport usb_storage usbhid hid tg3
> > [255264.517341]=20
> > [255264.517343] Pid: 18110, comm: cat Tainted: P            3.1.0-rc6-c=
ustom #2 Dell Inc. Precision WorkStation T3500  /09KPNV
> > [255264.517348] RIP: 0010:[<ffffffff8125dddd>]  [<ffffffff8125dddd>] ec=
ryptfs_decrypt_extent+0x13d/0x360
> > [255264.517353] RSP: 0018:ffff88031c03db78  EFLAGS: 00010246
> > [255264.517356] RAX: 0000000000000000 RBX: ffff88031c03db88 RCX: 000000=
0000000000
> > [255264.517358] RDX: 0000000000000010 RSI: ffff880170bd1ae0 RDI: 000000=
0000000000
> > [255264.517361] RBP: ffff88031c03dc38 R08: 0000000000000000 R09: ffff88=
031c03db88
> > [255264.517363] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88=
0170bd1a70
> > [255264.517366] R13: 0000000000001000 R14: ffffea0008351cc0 R15: ffff88=
0170bd1b60
> > [255264.517369] FS:  00002b38b966bb20(0000) GS:ffff880333280000(0000) k=
nlGS:0000000000000000
> > [255264.517372] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [255264.517374] CR2: 0000000000000010 CR3: 000000010b9e6000 CR4: 000000=
00000006e0
> > [255264.517377] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000=
0000000000
> > [255264.517379] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000=
0000000400
> > [255264.517382] Process cat (pid: 18110, threadinfo ffff88031c03c000, t=
ask ffff88005f920000)
> > [255264.517385] Stack:
> > [255264.517386]  0000000000000000 0000000000000000 ffffea0008351cc2 000=
0100000000000
> > [255264.517391]  0000000000000000 0000000000000000 ffffea000964c302 000=
0100000000000
> > [255264.517395]  0000000000000000 0000000000000000 0000000000000000 fff=
f88031c03dbe8
> > [255264.517399] Call Trace:
> > [255264.517406]  [<ffffffff81163f35>] ? vfs_read+0xc5/0x190
> > [255264.517409]  [<ffffffff8125e0b2>] ecryptfs_decrypt_page+0xb2/0x190
> > [255264.517413]  [<ffffffff8125bb08>] ecryptfs_readpage+0xd8/0x120
> > [255264.517418]  [<ffffffff8110daf4>] generic_file_aio_read+0x234/0x740
> > [255264.517424]  [<ffffffff8125863c>] ecryptfs_read_update_atime+0x1c/0=
x60
> > [255264.517428]  [<ffffffff811637fa>] do_sync_read+0xda/0x120
> > [255264.517434]  [<ffffffff81286a3b>] ? security_file_permission+0x8b/0=
x90
> > [255264.517438]  [<ffffffff81163f35>] vfs_read+0xc5/0x190
> > [255264.517441]  [<ffffffff81164101>] sys_read+0x51/0x90
> > [255264.517446]  [<ffffffff815dc082>] system_call_fastpath+0x16/0x1b
> > [255264.517448] Code: 98 41 0f af c5 89 85 58 ff ff ff 49 8b 44 24 40 4=
8 89 45 90 e8 c5 4d 37 00 49 8b 44 24 40 49 8b 54 24 20 49 8d 74 24 70 48 8=
9 c7 <ff> 50 10 85 c0 0f 85 40 01 00 00 31 c0 44 89 ea 48 c7 c6 50 cf=20
> > [255264.517481] RIP  [<ffffffff8125dddd>] ecryptfs_decrypt_extent+0x13d=
/0x360
> > [255264.517485]  RSP <ffff88031c03db78>
> > [255264.517487] CR2: 0000000000000010
> > [255264.517490] ---[ end trace 6beaa9aa4bd67546 ]---
>=20
> Did anyone else get a similar oops? Or does anyone have any clue what
> this is about? I haven't seen any fix that could be related to this, so
> I'm still really wary of using 3.1-rc*. ;)

I haven't seen that one. Was your kernel build using more than one job?

I'll take a closer look and try to reproduce it here. Thanks for the
report!

Tyler

>=20
> --=20
> Cheers,
> Luca.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOhIEiAAoJENaSAD2qAscKQesP/0xj8HCuMU2iUWPmJvjqE6mo
loD2R2EHdDNSGyLzLnRYUfmdN0pDuexOxhkr0iTVGrPgwNcen9algirAnXl47oH8
q3MYKl2u9pjEL7e/OS9l1Dvu8DViElPEsnhNC9UJ8cJ3lsiOSc5GPBCb9HwVgLgU
ZJO/EvlVDdELhmF8S0/lgEjZ4v8BsTChF3js5CKadcA1G5H7fmzjp7iL666ATAaw
SNOjDfXxQcrYvhzNPrepxhkMKu7HzdqPMt2BCAev9diUc9hlv3iBI7LtZMDvTMLA
4A89herDREfCa9svszsobdlgKtQZPd9wdUpEqG0M0Ic79i6XQhILC17lNGtEOkJE
O09bRpQr5Ui+QjbbK3P9gmBi3osg0BXoqWkpMbLR8u2J2dsDpAO22s/Bg+6n0bf8
ORz9TiWezpiTXjM151fRhNf6SnFe7vjZQIThfJyJz5uXcy0frMAYlK3QRpMIKiZ2
7t+BNgAePzv+bxVXn0dQcoEv1Pu40QfbYZ4NEm2S/K367+YupU+MAkP8XAQdsS8a
8ZdrQJ0Qjsj79tFxtDhxPEF6DJy2FduR/uk2Eidjq0VKiXJYoYL4i23pSJsVdUQw
Wo0x+hYZsQoSlLS+rL52CcIVa7X9ZHzqbkhFK1w9w/z8MWhPeX5vd4xO5iHajFfr
pm7zGBkFJ1FQAzRXEAbg
=VgAK
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
