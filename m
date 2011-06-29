Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab1F2Mie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:38:34 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:60333 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755653Ab1F2Mid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:38:33 -0400
Date: Wed, 29 Jun 2011 15:38:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] usb: gadget: add max_speed to usb_composite_driver
Message-ID: <20110629123826.GQ2760@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309350899-23868-1-git-send-email-tlinder@codeaurora.org>
 <1309350899-23868-2-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CGcXfQ1PUDCmwDYp"
Content-Disposition: inline
In-Reply-To: <1309350899-23868-2-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CGcXfQ1PUDCmwDYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 29, 2011 at 03:34:55PM +0300, Tatyana Brokhman wrote:
> This field is used by the Gadget drivers to specify
> the maximum speed they support, meaning: the maximum
> speed they can provide descriptors for.
>=20
> The driver speed will be set in consideration of this
> value.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

I have already fixed this one myself ;-)

--=20
balbi

--CGcXfQ1PUDCmwDYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOCxzCAAoJEAv8Txj19kN1m6sH+gL9C8AOBxV0myCzRCQ1oKrn
NOjUX3DQqoTRU8RYuVGzhU/FFufjYj59kURVjVXX7l7B7YOgGXHvlTcZCQZ+sjse
dEgf6ylQree/VglfU3g3MQ8ZBl37ra3ShEWsY4ItYca/tm3evMME5WRmyfTMra3d
MSWeARFtsbCBKJtvgx4m9ODkTOULD9+VRk3R+C+iX3ZuDooM0XtDEmBtVtCY1Nf6
3BFl3enp+DIJDozJTWBFWCAzCzqOiCIFU8+IfhLoezkR6aIjhPrNm/b0MMrGf6zY
91+prHAOukbdYoU+UV13L4nV9Wm0pfoJ7lQkCLvAnUR1GpZSTYdtSMMHbP/1CA0=
=9OKK
-----END PGP SIGNATURE-----

--CGcXfQ1PUDCmwDYp--
