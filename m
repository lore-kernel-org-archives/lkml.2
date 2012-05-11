Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab2EKDQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:16:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58155 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758876Ab2EKDQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:16:02 -0400
Message-ID: <1336706149.8274.431.camel@deadeye>
Subject: Re: [ 046/167] [PATCH] spi: Fix device unregistration when
 unregistering the bus master
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 11 May 2012 04:15:49 +0100
In-Reply-To: <20120509193335.GD15527@herton-ThinkPad-T420>
References: <20120509055029.588587017@decadent.org.uk>
	 <20120509055036.064659639@decadent.org.uk>
	 <20120509193335.GD15527@herton-ThinkPad-T420>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-zeOUlPfa/bdLJDvDsC6b"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zeOUlPfa/bdLJDvDsC6b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-09 at 12:33 -0700, Herton Ronaldo Krzesinski wrote:
> On Wed, May 09, 2012 at 06:51:15AM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >=20
> > commit 178db7d30f94707efca1a189753c105ef69942ed upstream.
>=20
> After applying this change, this introduces a bug on spi-fsl-spi.c, we
> need to apply in addition to this change commit
> 5039a86973cd35bdb2f64d28ee12f13fe2bb5a4c
[...]

OK, I've added that to the queue.  But doesn't fsl_spi_cs_control() also
need to be changed?

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-zeOUlPfa/bdLJDvDsC6b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6yEZee/yOyVhhEJAQrAEw//alBG/yMkl07LdxW82EvPRyoS4mqkjzC8
3uE/YHj1set1ZWukf6umuJlltyuZ3I+/2Vka5lucrD2OsGCdJjYIAUWXYGMRKaQA
6oBMVy+iqQqtJcqFexHQOuUY7mytw9KuM9IFgqtozHXjlFFO3KV0bcOsY0+7Pjo7
OMqcEEAk8gkfy3dbH1WoB7xCk9q49tVt3y9PL/SsWAmbf7gZD5hiz2s29OAdKNfK
zw8J/s3uG2DQast+mrPyidzRhMO+6HwPykcf/SMWR+qiy4lpa4IhTIpyutUcn0nu
F7il5FMOYio+CE1bxtoZkf9tKzKdWuR5Pp5UjbmWSixcy5XOCPLjjIzoDsLmt3/9
dojHXKNWlenZP3ajjb2Ge3+FhqWoSWBZ/HQG+gyEsm03hPcCpz3M35yJ/TIX16zY
C3vfnO4d7BGoe5RzY+cY1EIAHzRtkLJ6fx0p5K9Xx6RPv7ytwDGqUn/UGoE0tGoI
yYsWPCecnkXeG3ovBOEQwAvaq60YAy6G69HHWZjGwkEpcPIYeQcD9FxI8Fyl2bPX
UpZ33QqjM9B5KemMxc4PjF7+1k2iVZy89FWqC9HMaFWeVa63LFS9QZ2mvCaTDaW/
Rxa5Bx/OZWwUBp4Mrl0SjSXPsd8Bi2vWen3r0MxN+I19CtiM8CLH17Mmj/dvGX1c
2oLhQjQ9kYs=
=s5HR
-----END PGP SIGNATURE-----

--=-zeOUlPfa/bdLJDvDsC6b--
