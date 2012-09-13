Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2IMFpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 01:45:50 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:36476 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755541Ab2IMFpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 01:45:45 -0400
Message-ID: <1347515139.7471.7.camel@lappyti>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org
Date: Thu, 13 Sep 2012 08:45:39 +0300
In-Reply-To: <1347443867-18868-2-git-send-email-acourbot@nvidia.com>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
	 <1347443867-18868-2-git-send-email-acourbot@nvidia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-X7CYTU1tnldXpuBQcygl"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X7CYTU1tnldXpuBQcygl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-09-12 at 18:57 +0900, Alexandre Courbot wrote:
> Some device drivers (panel backlights especially) need to follow precise
> sequences for powering on and off, involving gpios, regulators, PWMs
> with a precise powering order and delays to respect between each steps.
> These sequences are board-specific, and do not belong to a particular
> driver - therefore they have been performed by board-specific hook
> functions to far.

The sequences are not board-specific, they are device (backlight, etc.)
specific. The sequences have been handled in board-specific hook
functions so far because there hasn't been proper drivers for the
devices.

If I were to take the same panel (and backlight) you have and install it
on my board, I would need the same power sequence.

 Tomi


--=-X7CYTU1tnldXpuBQcygl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQUXMDAAoJEPo9qoy8lh71ChgP/3m4mVfwgbYy4y0p23b9clXf
CyGznDlFYfwXfS0GZSWvdsU9MnaY5X8AWFidc6SjtbICMG0IzsPIL4Qv4093izVZ
/8O8r+6W0tXbvug++jHFFdXao2FZOvbzGRFCkIij3gnZB87SlKgpXL4IXY83Wmf6
DsZw18x3xeNT72vKB9oG0VGNCF3g475m+nRb0MXPxecLtLAl1XoK04TdyP+6NikJ
5MQEtKbp86hGh1a1AZiGVl15SYrsR7nVVmbxHsfJC2qQbP4vWdGIFhrjMl8vWq61
WS57bQ3yP/pIwz1QwapkHoz25+xXjIA9al7LTcBl5svlABfoJjXMyRB9Ini90pqv
ihYJ+l+sktIPErZLDtvJP4neiMyxxVB3gQ5k2emgvVk2ze1TAEm4AaL3lU1JULX5
LS3ed/kWT3L6PEu2FQDbL4PnKBbW+0IMIzrMT4Cc1h/IWsThQfbLke1YHJGX211e
oMGvKHe5gqkoAsOnYzglco6c0MViX5YqR5/MIhcLGbnM0ztX77feSdX0slnWnSn7
nufo6Vks8qbJmIXVuwxdSXlRpPSwF7sM3+HHRAmwjaZSx8VqcAjsj5eUclPDSLmV
yxMLMpPWYWZ2PMzA4aFWN1bFjwgy12gs8WNSnVhiZBj61SVxobFqbFDyGx/bqC+S
8PSrC/MZMcLG9Ys+RvCW
=SqAz
-----END PGP SIGNATURE-----

--=-X7CYTU1tnldXpuBQcygl--

