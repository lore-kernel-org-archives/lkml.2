Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1FPQ2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:28:51 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:40767 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756506Ab1FPQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:28:48 -0400
Date: Thu, 16 Jun 2011 19:28:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org, Amit Blay <ablay@qualcomm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to
 devio.c
Message-ID: <20110616162839.GY12230@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
 <1308231068-24038-6-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iDgFKLa5Kp4Ejml3"
Content-Disposition: inline
In-Reply-To: <1308231068-24038-6-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iDgFKLa5Kp4Ejml3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 16, 2011 at 04:31:07PM +0300, Tatyana Brokhman wrote:
> Allow user space applications such as LIBUSB, to request
> streams alloc/dealloc from HCD that implements XHCI.
>=20
> Signed-off-by: Amit Blay <ablay@qualcomm.com>
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

other than what Alan said, this needs major splitting. This patch is too
big. First we need to discuss the ABI details with the guys at
libusb-devel, then we implement.

--=20
balbi

--iDgFKLa5Kp4Ejml3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+i83AAoJEAv8Txj19kN1lYwH+wSsGk19fP/wu+XSFui1dsEp
fNJYLQ7Uqzt1Cyh3DMXF++MDFFaUUx7DPb54m8+BvX+hMf3swXhqNUOBYXCq5MxX
+hqXkIgVgeR1dxI47L1BnbloCsS82AXij+WBrtMwNYqzT9tbGclZ+A0yOoFkrAH5
X5QkZY01advbrkq47UZHeEqv7iuPKW7NV42XEsM5ta1WytCxINF8fQ2glsmJcTF/
ZCF39MFEWNi7jkqR0ceVwxZsgQ7W5EA+pUPF56JJr/nGf+sc/wqy9NmWU+kdAOQ6
vWWPA4tJJLibRXfunxVmvHCrSBw+NEuatmFGOtgeNgzh7cbIUbiwM+3bI8oBPQ0=
=Mvi1
-----END PGP SIGNATURE-----

--iDgFKLa5Kp4Ejml3--
