Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab1FIJoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:44:54 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:47270 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380Ab1FIJos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:44:48 -0400
Date: Thu, 9 Jun 2011 12:44:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v15 4/10] usb: Add max_speed to
 usb_composite_driver structure
Message-ID: <20110609094440.GE13552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
 <1307360469-29120-4-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="92pbEV8XGBb4M+SC"
Content-Disposition: inline
In-Reply-To: <1307360469-29120-4-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--92pbEV8XGBb4M+SC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 02:40:48PM +0300, Tatyana Brokhman wrote:
> This field is used by the Gadget drivers to specify the maximum speed
> they support, meaning: the maximum speed they can provide descriptors for.
>=20
> The driver speed will be set in consideration of this value.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

applied to gadget branch, thanks

--=20
balbi

--92pbEV8XGBb4M+SC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8JYIAAoJEAv8Txj19kN1UDIH/0LXPH0sBxvvdWXN72yErHRA
nLfqds2hbWv5b9hntCRyF5gjbCOnVKMTVyem7BBKwDluOh90bGnGa2afPEVJCOfa
Hcs+FM2hcQ1aOM1gupVUfKFT7cCQqNt3a2XeJ983DcoDZiDajE35eZxiLBFBvL3I
rUC83BWLr7e7Hh9qdT9t3nzaPwv9J8sMiDDq7ue7Q2vu+BBvJhFnTIBCJiCqeoO0
UjOXVNJRVB4DMv6D7y9tqPwVDtZ17ymx3b4c83yi/5wu18xGLFyQ92JC6bH14hnG
h9aflijfWNPBKCA+F8sUi1MEYXNwJ9pVaw0AJCoRRDD+4NOUL6erxx54Sdd8dgU=
=Fzqd
-----END PGP SIGNATURE-----

--92pbEV8XGBb4M+SC--
