Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab2FDJq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:46:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53942 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666Ab2FDJq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:46:57 -0400
Date: Mon, 4 Jun 2012 10:46:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH 1/3] regulator: gpio-regulator: do not pass drvdata
 pointer as reference
Message-ID: <20120604094654.GB3943@opensource.wolfsonmicro.com>
References: <201206032129.45414.heiko@sntech.de>
 <201206032130.34509.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <201206032130.34509.heiko@sntech.de>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 03, 2012 at 09:30:33PM +0200, Heiko St=FCbner wrote:
> Commit c172708d38a4 (regulator: core: Use a struct to pass in
> regulator runtime configuration) added the drvdata pointer
> only per reference to the new config array in the gpio-regulator.

Applied all, thanks.

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzIOPAAoJEBus8iNuMP3dnh8P/1fkOqEdVsDV4D1q4tgwwLEK
EEpChMLpxZ75/hDXsSQTbT4jMsVJvzZeydnAHoGrA+N7iKeQNcczTo/6Kj+zpr3c
+azfddbBJzuVcj1JPozkcpZ89TU6ArhDbIi4Rd2TEqeVUJN/BwBqtVAuB28zh6OF
u3O5SAZK7kjMpi/PU+ThvvNeXpguZPLMFoPbBk3CGtNQGl6g0ovAPt151f99N4yB
FD8URiL3wYkRIT2Pjg4F3bMj5HflJ0mJTPHe6D18149jqgr0A0Z1qDvwB+tQu5Q2
Dxrex7gC8kEeBYiWtKMkl275lpTO+LxFOQ2z+xIUDfxaeSjY3ESxeXO6N0dlUtZb
nwqgwQPDD5ksiZapxGD4hoRd3k7Nx0W+TvYacugleYExvpzTgJK94hLTkJpTAR09
j3/UIOFPLg0YEGI4vGnKwSfoT4SA91lZZ07UxMi+KHHjOcviZ51SyQ8vxzIsb7MO
7JcxbK6cJYtuJ5MHgBynYqkTB1oin9TEKi7QJ69PNXjVS/yIhYvFLFwzt/jnciXR
xG+YgVwDIhvWdyUiTBMgVTElHMocHqXH4lRyhymCtMQMtrjyIrqNpESQjlYwKYDE
OvyU8qjiAVuOneiBXy38kRJZGPDZFR+JxAgYr/GvYb3YDW2QNx7Sn5KdNjL13nCz
SjtOM3iQQNezSyPGI9Za
=/k/t
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
