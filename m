Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1DSRrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:47:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35224 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1DSRrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:47:22 -0400
Date: Tue, 19 Apr 2011 19:47:12 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, linaro-dev@lists.linaro.org,
        sameo@linux.intel.com, patches@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?B?7KCV7J6s7ZuI?= <jh80.chung@samsung.com>
Subject: Re: [PATCH 0/5] consolidate sdhci pltfm & OF drivers and get them
 self registered
Message-ID: <20110419174712.GA29314@pengutronix.de>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <20110419102031.GA4164@pengutronix.de>
 <BANLkTinfhb3vejJSM4y-C=3vk5RE76gPjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <BANLkTinfhb3vejJSM4y-C=3vk5RE76gPjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> BTW, Are there reason to omit the sdhci-s3c.c? Maybe Mr. Jung will handle=
 it.

The difference is that sdhci-s3c.c was more like a fork of sdhci-pltfm while
the others were users of it. With the new interface, s3c can be converted u=
sing
pltfm more easily. If somebody is willing to do that, this is very much
welcome. I'd suggest waiting for Shawn's interface to stabilize, though.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2tyqAACgkQD27XaX1/VRtDNACfT4IWD0wLs38e/nFIJLqwSiq4
VF8AoMBpBAt1Y4R4K3xSnr+A6UQbcYuS
=5iwB
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
