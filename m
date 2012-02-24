Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab2BXOp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:45:56 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:35403 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205Ab2BXOpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:45:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of balbi@ti.com designates 10.112.29.34 as permitted sender) smtp.mail=balbi@ti.com
Date: Fri, 24 Feb 2012 16:45:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Liu Shengzhou-B36685 <B36685@freescale.com>
Cc: "balbi@ti.com" <balbi@ti.com>, "Eibach, Dirk" <Eibach@gdsys.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: Commit 529febe breaks usb on Freescale P1022
Message-ID: <20120224144549.GR17178@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <48D3D52125C49B43AE880038E2E5314BB5BF89@SRV101.gdsys.de>
 <20120224100513.GH17178@legolas.emea.dhcp.ti.com>
 <48D3D52125C49B43AE880038E2E5314BB5BF8C@SRV101.gdsys.de>
 <20120224101432.GK17178@legolas.emea.dhcp.ti.com>
 <3F453DDFF675A64A89321A1F3528102170B1BA@039-SN1MPN1-004.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ceuyUbi+oA5bUa/n"
Content-Disposition: inline
In-Reply-To: <3F453DDFF675A64A89321A1F3528102170B1BA@039-SN1MPN1-004.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ceuyUbi+oA5bUa/n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2012 at 10:27:36AM +0000, Liu Shengzhou-B36685 wrote:
>=20
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Friday, February 24, 2012 6:15 PM
> > To: Eibach, Dirk
> > Cc: balbi@ti.com; Liu Shengzhou-B36685; linux-kernel@vger.kernel.org;
> > gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> > stern@rowland.harvard.edu
> > Subject: Re: Commit 529febe breaks usb on Freescale P1022
> >=20
> > Hi,
> >=20
> > On Fri, Feb 24, 2012 at 11:11:46AM +0100, Eibach, Dirk wrote:
> > >
> > >
> > > > > This commit introduces a check for the USB PHY clock.
> > > > > Problem is that CTRL_PHY_CLK_VALID bit seems not to be
> > > > present on all
> > > > > Freescale ehci implementations, at least P1022 does not have it.
> > > > > So this check always fails and the driver never gets loaded.
> > > >
> > > > hmm, you would need a revision check on that function then.
> > >
> > > Since I have no idea which Freescale platforms provide this bit and
> > > which platforms don't, I suggest withdrawing this commit and do some
> > > investigation on Freescales side to do this properly.
> >=20
> > Could be, but I would like to hear from Shengzhou first. Not sure what
> > Greg thinks though :-)
> >=20
> > --
> > balbi
>=20
> Hello, =20
>=20
> Just now I checked it on P1022, P1022 does not have this bit.
> So far what I know as below:=20
>        - P1023/P3041/P5020 have this bit, and mentions it in RM.
>        - P3060/4080/PSC913x do have this bit, but not mentioned in RM.
>        - P1022 have no this bit, not mention it in RM.
>=20
> I'm confirming this on more chips and will work out a new patch to fix it.

Ok, Greg will have the final word whether the original commit should be
reverted or we wait for a fix from you.

Happy hacking

--=20
balbi

--ceuyUbi+oA5bUa/n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR6KdAAoJEIaOsuA1yqREX0gQAItmDCOYJqkiXJipG62y1Q3u
bvvBN0La1OOVH/B6FR0qsgziUDsarx6i16kfap1P4rUVtJIM9S4bGbsoVcmE1FFt
sFYp8rvrpEFa/jX7A+tuTlsgVVf0KwFaMBo/VLP2sRWftYoi4ozHuaRYZUGNG+FZ
+cn1w2/n3LqDtf/eiBSbtMC4KBkuINmd41CkEr2WUqREiKmsRTniHjLpVQkqq3Bx
3hWrkzk2aH3o7M+ZHJxGWZqTJeLc8iDayjPTdiflqQWW3bnRLlNBBNyNR8tGm1d4
NLHN9FpVqm1be/LRwhoVgPBLrPJN21sqi1BLQ1Vca8pg7IUDvcG0HPuznMgZ0Eii
OkUQCBItM++BGl87p5qQMtSVT/uXRrC+yP3MscPshNtrBxsTPfQHfWNoABmdC/7S
H1V8o0QN8fAw/nsU8M9rnGRlMRlH7k2UmncEl1D2mzPpkO4Ggj77fK6Lol7PTMh+
5N3DA56gPxTRGTObZGR6oYgzFrNC+Ck15LRO1IMJNQqAaUdgUI3iKxRDPDH1CBbj
i1kMhJ8aActuVoNhd0qNxa3/dfpdJa7yog5VN0zirPB2jioWvR7v1MSd0JOa9KPp
dJM1qZIN+0cGGAdx0F6Hr2V9Mtb295yAka224V9lpFeblLS+uoxD+HiOTrgUUU+9
uXvbkJ1DAA/Gcf2wYkaz
=CrDR
-----END PGP SIGNATURE-----

--ceuyUbi+oA5bUa/n--
