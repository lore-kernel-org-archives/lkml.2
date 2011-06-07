Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab1FGSyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:54:31 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:55979 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab1FGSy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:54:29 -0400
Date: Tue, 7 Jun 2011 21:54:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 10/10] usb:dummy_hcd: Force FS device connection
 according to module parameter
Message-ID: <20110607185415.GD12242@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <016d01cc2541$0bfa5980$23ef0c80$@org>
 <Pine.LNX.4.44L0.1106071436020.1972-100000@iolanthe.rowland.org>
 <018a01cc2543$7273a5c0$575af140$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4JxvUTD846AMAZAS"
Content-Disposition: inline
In-Reply-To: <018a01cc2543$7273a5c0$575af140$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4JxvUTD846AMAZAS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 07, 2011 at 09:47:59PM +0300, Tanya Brokhman wrote:
> > > I'm not talking about dummy_hcd. It was a general comment about the
> > gadget
> > > code. I can't give you an example from the top of my head...
> >=20
> > Oh.  Well, if you're writing new code and you come across a place where
> > an error message really is needed, you should add the error message.
>=20
> Ok, I'll take that into consideration. Since I'm new here I was "afraid" =
to
> add any changes that are not really required :)

just remember to put unrelated changes on separate patches ;-)

> > But if the parameters are contradictory, you don't know _how_ to fix
> > it.  If is_super_speed is True and is_high_speed is False, did the user
> > want to add SuperSpeed support or to remove high-speed support?
> >=20
> > Besides, the best (i.e., easiest and most likely to be correct) way of
> > fixing the error is for the user to issue the modprobe command again,
> > with the correct parameters this time.  Therefore the driver should
> > fail to load, so that the modprobe can be reissued with no need to do
> > rmmod first.
> >=20
>=20
> Ok, agreed. I'll update the patch.

Cool, I'll wait for a revised series.

--=20
balbi

--4JxvUTD846AMAZAS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7nPXAAoJEAv8Txj19kN1NgYH/2eXbABjv598Ik8Vwl6dScT6
yUJp9dBqxnUCffWRS59Vv92JvW0wiXiueWq8TzZmBiNmwPzn1rb/KgJvNeJkS1wo
T1vxwN7Q5WE0zcdIhYGsNx5b8pVpo0YTc2t0mLAfyEwM+85QCU8g+hg0gzQpAXIt
FdXJiCw1ja07uNvZZkTEtdnDwC0HFUBom6/EcQrAM6S6CmXFX8gBNFnSbxM9tIrv
gZiUBhaX3XzLTSkSLBaVLwx80QmkY/A7QilE7KSEa7YEHnY0kHHQpDG+Hvsxgf7t
Pz7eTbUFztLykT8u+YMk1kg+yO0vb/ku8uBeXDwK459EToPRI4vh4I2YgCg05tg=
=kJbm
-----END PGP SIGNATURE-----

--4JxvUTD846AMAZAS--
