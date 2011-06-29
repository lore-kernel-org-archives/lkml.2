Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1F2Msf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:48:35 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:40833 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565Ab1F2Msd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:48:33 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 08:48:31 EDT
Date: Wed, 29 Jun 2011 15:48:24 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] usb: gadget: add max_speed to usb_composite_driver
Message-ID: <20110629124822.GS2760@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309350899-23868-1-git-send-email-tlinder@codeaurora.org>
 <1309350899-23868-2-git-send-email-tlinder@codeaurora.org>
 <20110629123826.GQ2760@legolas.emea.dhcp.ti.com>
 <051801cc365a$73187140$594953c0$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jZNlLGxhPb4urluq"
Content-Disposition: inline
In-Reply-To: <051801cc365a$73187140$594953c0$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jZNlLGxhPb4urluq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 29, 2011 at 03:45:35PM +0300, Tanya Brokhman wrote:
> > I have already fixed this one myself ;-)
> >=20
>=20
> Oh, ok :) Thank you!

it might take a while for kernel.org to replicate things, maybe that's
why you didn't see before ;-)

give it a few more minutes and check my gadget branch to see if it's all
good, I'm going to test it again on beagleboard to be sure nothing is
broken.

--=20
balbi

--jZNlLGxhPb4urluq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOCx8WAAoJEAv8Txj19kN1QCcH/j32nT8SsBgPmVoqHqFFnGOa
dwGNll1JM/vQDI8De+HbGZnvkEa90MOiOd2MNhfOLniKhT+OIBVGovB1MXLN5kHa
UQ/Ribr5gEW11BZAgHPoG4mW3HPBsYmJqlYP1sEsT4QXY1MwfmlnkCpdEBypyzfP
G728Qm18pAR8jFlHzVFVwdpwSiXQKoGersUbEZc4uKagJ4WVKBPXXiAMgxAl36R1
ZQ130yp4twM9hzCUlKeReSl5fsnTIV/au5v9SFQcLVosjUnf5h1V5qgjTUtt0Bhk
O46ZsFHqj5nlzAcOYR1YW2YJzkWTZ9kBDNJkN3uqx+bcX0zfiLtS7vbndY8NKxA=
=D54t
-----END PGP SIGNATURE-----

--jZNlLGxhPb4urluq--
