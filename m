Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab2JaMsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:48:35 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:50865 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab2JaMsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:48:32 -0400
Date: Wed, 31 Oct 2012 13:46:00 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: BUG: enabling psacct breaks fsfreeze
Message-ID: <20121031124600.GM20752@pcnci.linuxbox.cz>
References: <20121023094351.GC27919@pcnci.linuxbox.cz>
 <20121031121517.GD18424@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fDP66DSfTvWAYVew"
Content-Disposition: inline
In-Reply-To: <20121031121517.GD18424@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7966382 records (last update: 20121031)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fDP66DSfTvWAYVew
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

thanks for the reply, sure, I'll gather and post requested info.
One more note before that, the problem is with psacct, not audit
 - psacct if I'm not mistaken  (and as opposed to audit) doesn't
use any userspace, kernel dumps information directly to fs,=20
which might the reason for deadlock..

BR

nik


> > Should more debugging information be needed, I'll be glad to provide wh=
atever I can..
>   Thanks for report. Hum, I'm not sure how the deadlock can happen because
> AFAIU audit sends a message via netlink to userspace and whatever audit
> daemon does with it is its private thing. Can you please run:
>   echo w >/proc/sysrq-trigger
> after the machine deadlocks and then take dmesg and attach it here? You'll
> have to have the shell prepared and use serial console / netconsole to ga=
ther
> dmesg or try your luck with copying via ssh / netcat.
>=20
> 								Honza
> --=20
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--fDP66DSfTvWAYVew
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlCRHYgACgkQ3xdJJrLygV5sXgCfbK17AiHMUhZPyu6I7GcfzkZJ
TPQAoLuxl+e1SX6iPDYPGZ/lLKFlRicX
=IZph
-----END PGP SIGNATURE-----

--fDP66DSfTvWAYVew--
