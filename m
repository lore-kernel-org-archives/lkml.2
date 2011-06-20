Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1FTN3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:29:01 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:51015 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286Ab1FTN27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:28:59 -0400
Date: Mon, 20 Jun 2011 16:28:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gadiyar@ti.com, parthab@india.ti.com
Subject: Re: [PATCH] mfd: omap: fix the crash during omap ehci or ohci driver
 initialization
Message-ID: <20110620132851.GJ14262@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307367739-20110-1-git-send-email-keshava_mgowda@ti.com>
 <20110620132626.GJ22420@sortiz-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="++alDQ2ROsODg1x+"
Content-Disposition: inline
In-Reply-To: <20110620132626.GJ22420@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--++alDQ2ROsODg1x+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 20, 2011 at 03:26:26PM +0200, Samuel Ortiz wrote:
> On Mon, Jun 06, 2011 at 07:12:19PM +0530, Keshava Munegowda wrote:
> > From: Keshava Munegowda <Keshava_mgowda@ti.com>
> >=20
> > Oops are produced during initialization of ehci and ohci
> > drivers. This is because the run time pm apis are used by
> > the driver but the corresponding hwmod structures and
> > initialization is not merged.=20
> You mean they're currently checked in a different tree ? Is that a
> public one?

it was supposed to go via linux-omap tree but the patches got lost in
the limbo :-(

--=20
balbi

--++alDQ2ROsODg1x+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN/0sTAAoJEAv8Txj19kN1cowH/2ukogGk7X4iTCZUcyrazn/d
CwSFIMKdC6/nXoIUjXpNiBwzF4ws6aR5r+MnBG4zKT5sz7Zxq50lHC/sHHyYMMkM
/MDwMPRs7aOZDgJGLtQrh7JAvmzDDp+RC/hhQKPPXz+ESiAfCBQJDk5IZm+f9ILT
sin4VpRSxd13aRfvd6q6RpaY+g8wlb5A1U5Q//jRLDOzrVt/n87ry/B7zxYOm5uq
SML0NTDXVJ6LC6VkYKu1RTAzvUuW8U+aP3b3qJujveftHAfVJ9ceHOhLPCW2orUW
yF2lcDjqMd/Ndt1LJGLMeic+0NDuWagvn0aZHWxkFNCLp2hQIts3YO1zQh4CMoA=
=XcKM
-----END PGP SIGNATURE-----

--++alDQ2ROsODg1x+--
