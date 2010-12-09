Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab0LIC0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 21:26:48 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:46751
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890Ab0LIC0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 21:26:47 -0500
Date: Wed, 8 Dec 2010 18:26:44 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Greg KH <greg@kroah.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
Message-ID: <20101209022644.GB15472@one-eyed-alien.net>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Luben Tuikov <ltuikov@yahoo.com>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <233716.61101.qm@web31813.mail.mud.yahoo.com> <20101209015204.GA8339@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <20101209015204.GA8339@kroah.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2010 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Wed, 08 Dec 2010 18:26:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 08, 2010 at 05:52:04PM -0800, Greg KH wrote:
> I'm not saying that the in-kernel driver is perfect at all, and it's
> author is getting annoying by refusing to answer my emails, but still,
> please work with him to get the in-kernel driver to work up to your
> needs.
>=20
> If you have problems with the maintainer, please let me know and I'll
> see what I can do.
>=20
> But again, this driver is not acceptable as-is, sorry.

Greg, I completely appreciate your position on this.  I would just like to
add one thought for your consideration:  If, in fact, Luben's driver is
somehow "better", it would be a shame to penalize users with a
lower-quality driver because they got to the submission first.

Now, for that to apply, several things would have to be true.  I do not
know if they are true here, and I leave it to your discression to
determine.  But, your stated problems getting hold of the maintainer make
me wonder....

That said, unless the current driver is really bad, and Luben's is
tremendously better, it seems to make more sense for everyone to focus on
improving the in-kernel driver, even if that means slowly re-writing it
over time.  Lord knows that is basically what I did with the usb-storage
driver...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I want my GPFs!!!
					-- Stef
User Friendly, 11/9/1998

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFNAD5k3gL8qCooyc4RAr0+AJ9g7x+ly9CPfqEhMrtnug60hG4oUACfWiJp
5BvAh0MdG7AUM1mvGGybZaY=
=DNyp
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
