Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1DRKvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:51:54 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:42193 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369Ab1DRKvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:51:46 -0400
Date: Mon, 18 Apr 2011 12:41:08 +0200
From: Jan Losinski <losinski@wh2.tu-dresden.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: losinski@wh2.tu-dresden.de
Subject: [PATCH 0/1] Input: ati_remote - extend keytable for medion remotes
Message-ID: <20110418104108.GA4876@atlantis.wh2.tu-dresden.de.de>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
X-PGP-Key: https://box.losinski.de/public/pgp/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

the following patch will extend the ati_remote input driver to support
multiple key translation tables. I have a device produced by medion that
is supported by this driver. Unfortunately the single hardcoded key
translation table does not enable all the keys and maps some of them to
completely wrong key events.

So I changed the driver to choose another table if the product-id is the
one this device has. For any other device the old "default" table will
be used. I also provide a full table with meaningful key events for my
device.

I hope you can merge this patch to the mainline version. Please let me
know if this patch causes any issues.

Thanks,
Jan Losinski

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2sFUQACgkQ1Hv7AMjH+2E4LQCfd2k0EqzQlYD3FB2PUoJY4n9r
AbEAn1zT1uiY2GtFQkTZen8DXVU5Mt2Z
=TjHz
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
