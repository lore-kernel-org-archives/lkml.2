Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1F2MnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:43:10 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:38107 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755700Ab1F2MnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:43:08 -0400
Date: Wed, 29 Jun 2011 15:42:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] usb: gadget: add SuperSpeed support to the Gadget
 Framework
Message-ID: <20110629124257.GR2760@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309350899-23868-1-git-send-email-tlinder@codeaurora.org>
 <1309350899-23868-3-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K5roPakIqCb4O6y8"
Content-Disposition: inline
In-Reply-To: <1309350899-23868-3-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K5roPakIqCb4O6y8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 29, 2011 at 03:34:56PM +0300, Tatyana Brokhman wrote:
> SuperSpeed USB has defined a new descriptor, called
> the Binary Device Object Store (BOS) Descriptor. It
> has also changed a bit the definition of SET_FEATURE
> and GET_STATUS requests to add USB3-specific details.
>=20
> This patch implements both changes to the Composite
> Gadget Framework.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

had already fixed this one too..

--=20
balbi

--K5roPakIqCb4O6y8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOCx3RAAoJEAv8Txj19kN15/YH/1wrRyC2VmnuFBG2gUHPHvsP
BUDZ9IoN1i3bzxLhBMIcbMK12+J9/vtvQQaZE0cjiSzqxEFKgvJTa1O5yg0b6V8Q
TB9smqfAVxs9rGO5/+fARXds4Xugrj/NLGM40EhdZ7cs0k7N8u+EWQxdFzNdW80l
AisGXxOs6y7yViyu7aC0Fki8MVhPbMWR4wK8K2f5yWEeVMwFg/z7elkEkssXNgan
0yMUirFdN5Und3gSBUetzjlnrJbelqiBXiF/4a0ieXAoqlisrtT+YRlNTaNca1L6
qNEEmZjDhBBU0/dMzQkZiZXBx+Fwrqc/G8GvyZK5ZL3kCxr9IlePNLb6/vKQmys=
=vXKt
-----END PGP SIGNATURE-----

--K5roPakIqCb4O6y8--
