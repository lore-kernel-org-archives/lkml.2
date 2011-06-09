Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab1FIJoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:44:24 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:41921 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734Ab1FIJoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:44:22 -0400
Date: Thu, 9 Jun 2011 12:44:17 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v15 3/10] usb: Modify existing gadget drivers to
 use config_ep_by_speed() instead of ep_choose.
Message-ID: <20110609094415.GD13552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
 <1307360469-29120-3-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mu4SaHkdL1Az71rA"
Content-Disposition: inline
In-Reply-To: <1307360469-29120-3-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mu4SaHkdL1Az71rA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 02:40:47PM +0300, Tatyana Brokhman wrote:
> Remove obsolete functions:
> 1. ep_choose()
> 2. usb_find_endpoint()
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

applied to gadget branch, thanks

--=20
balbi

--mu4SaHkdL1Az71rA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8JXvAAoJEAv8Txj19kN1RE0IAKe1VtVV7I70dpAK7avGVbjA
OlFLuxZEzFwaRKlGJDcZPYUBTAxio1vf0BM/c2+vHlqXslcrbaBvosn4nDN152rC
qSmHcpaqJr54uhRen4hRv3mtHWJN2R+FAAvXQPwcm9NKb01j2q2KUOVq4vxj4SgP
qVpeVN9VIBS0voqMaaGl6Z7scnjQ9J9mkMw8V85tlqdtBhaxbFl5Z5SHRh//j5X2
OBCgBL7ceTjxLAfcKE1kvmA2Kk18Vlbq7bNZg0WwHYq79VDZVkYkhZPX5Yz41BP3
3Mog/8+jNMmPsJQmVlAuQV6cmRua4KEmbIXDeNM2u7h4NJE17URvTWzfvCOPGMU=
=obkZ
-----END PGP SIGNATURE-----

--mu4SaHkdL1Az71rA--
