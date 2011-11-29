Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1K2FMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 00:12:14 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38267 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1K2FMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 00:12:12 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH v2 1/7] firmware: Sigma: Prevent out of bounds memory access
Date: Tue, 29 Nov 2011 00:12:10 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com, stable@kernel.org
References: <1322469860-8210-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1322469860-8210-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1773647.zGVGVXDcfA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111290012.13051.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1773647.zGVGVXDcfA
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--nextPart1773647.zGVGVXDcfA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJO1GmsAAoJEEFjO5/oN/WBgoEP/3to4cwscxu3B6V4PryFIaEn
5jLDTAxx91oVdVzVlh20f8OeEbErEaGsACP7W0fy4TxUMzl7ZR4X7o+YS/t7xThN
svKDKSIVDDnP5EvN6aBP2ad9fYOma19W9wrEz8/3tDFTV57WzMdDSGm6N5agOY1G
WtkFh8s7PoML+oqp2xT4GrK0cG3UEeeaUid/0A9o6A2UWLnjfS/U0Zk32AaviH8T
HpWKP+pKIylSlyYBML6XS+P8TWNB32AgvBmlOnTVGC0qo9s75bKLEDFZwlT7cxYm
xhpZJz1FRdY/7I8Si21cdWhpZloopxM+hX236CbvXg+70MPNG6X5yhIJgKCKAzmh
DPFuxvKnFlusto6YMMt2uDDqTdXm66oTXF1ndUA4T31dQ7xIWCqc2FrgJ1PTROKi
KQd9LR8Uvj7Ri2VHanezW3CFLMvE1B51NArCgrlmdxIgecFPEK8b2wirpNprKlPB
0wmzP81N47QTzDPuGcm85xlPzl0Lb6lJ8CdQZQD7v1AWAIhcrIn1XBEvKLf1ebnV
pEjl3K/DoBC91OUFK4fl0lQYLdfrFFngMUdUHFlOxHqMfHLoKwIW4nh/3E2l4MUP
Jhp0Pfiist0WsB/vqsTkMdUoIwAQWBaYyHnN30ASxCRsy6iKiD2iZrIw3d0FGnPw
Sne8WvflGrAjvnh0dnqm
=vLvx
-----END PGP SIGNATURE-----

--nextPart1773647.zGVGVXDcfA--
