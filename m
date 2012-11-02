Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2KBKmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:42:54 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:44731 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab2KBKmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:42:52 -0400
Date: Fri, 2 Nov 2012 11:40:18 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: BUG: enabling psacct breaks fsfreeze
Message-ID: <20121102104018.GG20752@pcnci.linuxbox.cz>
References: <20121023094351.GC27919@pcnci.linuxbox.cz>
 <20121031121517.GD18424@quack.suse.cz>
 <20121031124600.GM20752@pcnci.linuxbox.cz>
 <20121101093723.GC6584@quack.suse.cz>
 <20121101111957.GD6584@quack.suse.cz>
 <20121101142325.GD20752@pcnci.linuxbox.cz>
 <20121101225053.GB31937@quack.suse.cz>
 <5093977A.9010507@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OWym5pP/pDvoNOpg"
Content-Disposition: inline
In-Reply-To: <5093977A.9010507@gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7977435 records (last update: 20121102)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OWym5pP/pDvoNOpg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> I saw this behavior (task-hang) when I tested the fsfreeze code. I was
> writing a little patch to replace fsfreeze's wait queue with a killable
> queue, in this way the user can do at least "kill -9", but since the
> behavior was the same before your patch I didn't send it. I don't know if=
 we
> can break any previous behavior. The funny thing here is that it's like if
> fsfreeze freezes itself :)

I think freezing all tasks ain't that bad, my problem is it's not possible =
to
start fsfreeze -u to thaw filesystem..


>=20
> Marco
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

--OWym5pP/pDvoNOpg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlCToxIACgkQ3xdJJrLygV7SewCgh7xBxiiwqnRtmsLCse+OX6Xl
N28AoLj0SvY6/t2iQMB8CNADGUPscVSC
=x4nH
-----END PGP SIGNATURE-----

--OWym5pP/pDvoNOpg--
