Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab2J2QTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:19:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43201 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173Ab2J2QTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:19:18 -0400
Date: Mon, 29 Oct 2012 18:13:24 +0200
From: Felipe Balbi <balbi@ti.com>
To: <Vineet.Gupta1@synopsys.com>
CC: <gregkh@linuxfoundation.org>, <alan@linux.intel.com>, <balbi@ti.com>,
        <arc-linux-dev@synopsys.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7] serial/arc-uart: Add new driver
Message-ID: <20121029161324.GH27566@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351322232-32137-1-git-send-email-vgupta@synopsys.com>
 <1351322232-32137-2-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+PbGPm1eXpwOoWkI"
Content-Disposition: inline
In-Reply-To: <1351322232-32137-2-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+PbGPm1eXpwOoWkI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 27, 2012 at 12:47:12PM +0530, Vineet.Gupta1@synopsys.com wrote:
> From: Vineet Gupta <vgupta@synopsys.com>
>=20
> Driver for non-standard on-chip UART, instantiated in the ARC (Synopsys)
> FPGA Boards such as ARCAngel4/ML50x
>=20
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

I'm by no means an expert on the tty layer, but this looks a lot better
than previous version.

FWIW:

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--+PbGPm1eXpwOoWkI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjqskAAoJEIaOsuA1yqRE11sP/iWHvpFHz0z8iAsqjblmzTAe
K2aN7ZvwiMNKR/WtP1qlxRQ6wwIJqHg5iegxDvsh1KFXXQKyVAMTIbxWqujc8hPG
I32IE5R3HzNiDFtxS7CnoAiY6DGDlkV4tKqNX/a5ZHMsXUNLKbMPhlpD49NY9UNL
Rg3px8uHsdl2Q4/gs0Rx3rH8rmmVdGC5WNWlcu3tt5IcGirAGfBURVPPw136h1lc
dAjB44CFitEpr8HDltXnNFRil8zkcISSt4q/J+4e/4C7wpN4I2auUw744pNl28vM
Rvcqub+0MMPCJshO6Z86U7El6+cdi5PsHCLuF4g/6bzjmGk2Hf+2+aiHAW/1DsjN
gYK9CoaCmpkPHsorj8p+t1qZ5zUyb7LLCe7AAKJ57XI/NLPxMFgFlJ5u1HOnAaYz
Ogl6SxDFVtrqmEbSJ6hm1kUUS8wdkNeM3m3G9oTjgASjfPTfe2l+cTx5yKIJ8J2i
mqZmWvWm1oFm0XmnVInmyryghBfjEYtxj/e2BFw4VpVpzhcDNZpv224/9DAnv1Vj
uf4GYohsjP6WbXh3hPScz6wApaz0G1mrKPK3vKFFHHGCLDBeaJjAZgKLyw5L2doh
sJ39HntvstbbiU8+ocygLcPHGh2maPENVfTcmbjnEJ6MEtFBRgod6mxEVxcsLKqQ
FxDgKm0XxXcxk1lkMTrr
=cW/y
-----END PGP SIGNATURE-----

--+PbGPm1eXpwOoWkI--
