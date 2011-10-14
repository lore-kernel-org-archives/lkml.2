Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1JNHVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:21:06 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37363 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932100Ab1JNHVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:21:04 -0400
Date: Fri, 14 Oct 2011 10:20:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 09/10] USB: move to dma_transfer_direction
Message-ID: <20111014072058.GE20436@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
 <1318570705-17595-10-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="idY8LE8SD6/8DnRI"
Content-Disposition: inline
In-Reply-To: <1318570705-17595-10-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--idY8LE8SD6/8DnRI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 14, 2011 at 11:08:24AM +0530, Vinod Koul wrote:
> From: Vinod Koul <vinod.koul@linux.intel.com>

please add a description here.

> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/usb/musb/ux500_dma.c     |    4 ++--
>  drivers/usb/renesas_usbhs/fifo.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

can you split this patch into two parts ? One for musb and one renesas ?

--=20
balbi

--idY8LE8SD6/8DnRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOl+LZAAoJEIaOsuA1yqRE14MQAIbueVyMOUwrMBXD+vkVJgHb
o5qhYHzzL1EsIVXokwQPuOzqJ6S6yXO1v7K4FO0bhD4nwtSpWrZEsqdm18DL/yE+
6nErgpnadFzJFuALoWwi7eThf6Z6LIFZeFalHsHJC1FgAT5yDZ06NCZFqXTpNRdv
2UdFWCWNBO8jsAF2rVohS3xp2PhDO+w9tDH7N3k7KM/o4HqYm2D3KUFLuOLjHOPm
bJLhfVoeTxbUxA1g2MOSTjyeSKLti63LdfTw3yiDQjK6Rg5mfCHcIE79qho3f4Cr
tAtb8SsRyePIc0fbl+EK4lnOBOkuak5nDsjaBChD2ZbmQRfwaCEZRaTi7xKsZ7fH
8jX+4QJFhkHNY5Q1k5SwfoEyHFjuMc0LgY/Agat//Fh17Q2ZwNltPs0XOcH3CS4T
OYkOKzNVyEt2yeheeL6cqvMm7YA1hw/rCfUJMsducgfuuyVHX1MYLkEe1Gz2vbIP
cqND9I53m0pInT1y7ViyWOUDpiCDYfB8bLt5B/YOsyPA9sXFOxvTuETLVvGdqMab
NWHVfdwdfuWddiiAe9XCWSuB5Aik0bCTbnBtjNXMsPN70+PIS7VnVS2Dm8jxxuCu
M04HKQLMJI3qEIdqCL+FomhwZ6vUeS5pp4gayGmX2b2owUDsOvYBfQvYHm4c2XL6
6NT/nT7iZ+QyhCgwWXFX
=u+1B
-----END PGP SIGNATURE-----

--idY8LE8SD6/8DnRI--
