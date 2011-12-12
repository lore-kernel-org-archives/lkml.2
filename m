Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1LLTlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:41:18 -0500
Received: from imr3.ericy.com ([198.24.6.13]:44192 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab1LLTlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:41:16 -0500
Date: Mon, 12 Dec 2011 11:39:37 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.2
Message-ID: <20111212193937.GA12664@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon subsystem updates for Linux 3.2 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter

------

The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Axel Lin (2):
      hwmon: (jz4740) fix signedness bug
      hwmon: (jz4740) Staticise jz4740_hwmon_driver

 drivers/hwmon/jz4740-hwmon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO5lh5AAoJEMsfJm/On5mBnUkP/RfQCGynbcQ+6ZwapnQBRtrD
yIWEZVHBrb7IyPbbXVLdb6v7fP4QtJ2IOaUQDinpXtmOcTETryVOLItqhad487kj
RseJBrL5ZLtdG7KrP1qsFf5o8xZ0CRKpUplgqwdTAdD+4QiJi+knRZbHBNZNfpnG
Te4CksENM0mSJIZoU2wJGsjHTFXm1f7JsHtA90tw0U8bVI8qBvlxIcd0sdasDuyu
NYtMoijHmd1FrVJEUZ97fXgoohyEoYPoWWqLbPbNlHhP1D0ssQ/+KcqVZB9kwY1Y
7991/yJnltZ5RzJUAcfCa034LeDebajYILsvpy37aGGOZAlbc5tJb4WA4urX+CoT
gLC5YHv2No+VUecqSKIeVKtM9zq/fYKudJOc0kIg8lr7E9Kdd6gX4KaDBsdspaRX
Pa0rwZqpihNMYvasM9U8855/ST2RWj4e0U8y0qI77HgoBBcMHMeGh1ZvPAXzR2du
skRHpnrVbfYxRBfP2QNAO2MiCYAisuqDR8s4fq16WcQMxvFMK6he/fy+FLG3pX46
Yxan4YCN8cvsaBDPrRmtZvnHc1zB7ObQoDCTOiVsyz/yxRXjTSNlqcCAoomenucM
SNQvG3ToWNGgJzCm3uSMCwB691zQPcS0Ll4ed+fUxeqNflwdZw09TCnTZlCAJAny
YedblrCCLIYw/i4Ih9r7
=LD2i
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
