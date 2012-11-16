Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750840Ab2KPIuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:50:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:28019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab2KPIuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:50:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,263,1352102400"; 
   d="asc'?scan'208";a="248120937"
Message-ID: <1353055849.20111.7.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/8] mtd: diskonchip: don't warn about ARM architecture
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Date: Fri, 16 Nov 2012 10:50:49 +0200
In-Reply-To: <1352238933-4886-2-git-send-email-arnd@arndb.de>
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
	 <1352238933-4886-2-git-send-email-arnd@arndb.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eNXl6kIH6env3rQVVrCs"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eNXl6kIH6env3rQVVrCs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-11-06 at 22:55 +0100, Arnd Bergmann wrote:
> Enabling the diskonchip drivers on most architectures results
> in a pointless warning "#warning Unknown architecture for
> DiskOnChip. No default probe locations defined". The driver
> can in fact handle the default location already through the
> CONFIG_MTD_DOCPROBE_ADDRESS, which gets set on the platforms
> that need it, and we get a run-time error if this is not
> set correctly.

Pushed patches 1, 2, and 3 to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-eNXl6kIH6env3rQVVrCs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQpf5pAAoJECmIfjd9wqK0Lc4P/03ountaYjOzekyNt2lov3zV
HzkITwuBsKt7j/mMMQnRxr5inKeogDRZJQkUctnAvmDby5s7i0+CwuRJn0Ft0V/6
aZ0qvfJT5z6UKuHAu6JDD7bRQzZpYE6ERJwP6ToABlVyajW2PZpOQf9hx+SMFqCT
14uzrHhQ8ikNw5uBHRxHvszW1EN/buGy9hYCof5h08YjtFLbf6hW1CEnH0IFuwGs
YuSQkkDPJTECWAJoTmixnXP/L8YUnB0gtGDIr8Y3bwRurw8JSt3a1MHrNNki10F1
pJMKoK225nmH/rG3umTFtZTpTxkHL0IBd8u2Rp/iaGAnD/+i3TFcSJSRNCj2gCso
899hU6bvfVrLXunKfngY9LoE3FOaNZBGwmH4h7gzJxXnwXJ1pmDae0QNowvUpcQ6
ZA1Zi3DTdiUJmZvSRKnWs6rpJXx33sKj8tA8gDUlZZmGupWkmbxtMBg/BxF8AXTb
bA3bC7ZYqeYIxjTmg26nxlLcTMiAHjiSY1mlfMAO9nW1AHA81hDFbaVP8ZaOh4XR
RBa4A6eQi2HN76/E14T7YOOv4DwD04+GzgSQTH1JipNXUp9WPPKOidkwh3AbFUFF
qPeYN/Ox9L0iY5nQpg5QtaXJSZ5xKy84dvMq/3zAai1u9236NT05A3cwEhUJExaV
K3v06JeW4E7RQJ+yD53R
=V7ou
-----END PGP SIGNATURE-----

--=-eNXl6kIH6env3rQVVrCs--

