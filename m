Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1KHOCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:02:37 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:33837 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932341Ab1KHOCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:02:34 -0500
Date: Tue, 8 Nov 2011 16:02:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2 1/2] USB-musb: move to dma_transfer_direction
Message-ID: <20111108140222.GT6921@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
 <1318610350-23335-1-git-send-email-vinod.koul@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H7L1MAC6sWqaQENJ"
Content-Disposition: inline
In-Reply-To: <1318610350-23335-1-git-send-email-vinod.koul@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H7L1MAC6sWqaQENJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14, 2011 at 10:09:09PM +0530, Vinod Koul wrote:
> fixup usage of dma direction by introducing dma_transfer_direction,
> this patch moves usb/musb driver to use new enum
>=20
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

applied, thanks

--=20
balbi

--H7L1MAC6sWqaQENJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuTZuAAoJEIaOsuA1yqRE2PsP/inJ9tGGX7ihnOiUuyk4AX9x
KOSIjC0FabNYrBtOSKh++1yXxKmZ2kyyyCYMu/SpO49OWVyCb94myLS915krg6b4
TWEKhM0MhiOU9URGh7iR8hg+fkIWp8qg32/yLV7cscz/IGrguLiH3jTAkKJOt/gO
zQ1Jx/1rHkgO0e78BxQcAY0xkgebHZQi8vZGp0zBTTpkTNDGHr/jUBTs20EOPkcL
0KQRxmUZn9EcbEibJmz6ML2mE10lzIBKmP869o/UaKtgbrsyueYf7fe8i+QETBJH
Ae0t0wOTey+fhB0kn6TC8vcbtfaQA+LPShAgk6KhYjEjrfPvh1ODmhPpGhDX3q+S
wBRkzk0WwusFNdfk7ku3MiElYdtJaItcZxjIXqnNZt2MJdRYy1KEeUIHMVQpHNOE
OT/Ehz6B3bnjthAiU3/K2s/+EggFiYyDTL9EnyVglCaK8UOcTiroSo/DVMMP+1ts
nd3nyvOfKC65Be8Blu8WqEQscuhqws6ZWkf2fKZjGP/dz8ZWe+Vr9sgvaUOfk+0w
C9AtRUAXz3xuIPcGYvi8dnQtNMnFPxNjxkZQvdS9lgmg6S9gAvEIraXPs69sMbOM
bht74WKdYcUsYdw28NSXA/pvlkT5+cTvIvU1Vj34P6jP2OKcWjBZgJoyPB3L1EDY
sfmnC9FMpB0AHkKWQDzn
=g9ks
-----END PGP SIGNATURE-----

--H7L1MAC6sWqaQENJ--
