Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1JTVQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:16:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53518 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab1JTVP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:15:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Subject: Re: [RFC PATCH 06/17] phy_driver: Add and use phy_driver_[un]register_multiple()
Date: Thu, 20 Oct 2011 17:15:54 -0400
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@conan.davemloft.net>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Baruch Siach <baruch@tkos.co.il>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com> <1319144425-15547-7-git-send-email-Kyle.D.Moffett@boeing.com>
In-Reply-To: <1319144425-15547-7-git-send-email-Kyle.D.Moffett@boeing.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2518635.yaTGvqVo4f";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201110201715.58441.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2518635.yaTGvqVo4f
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Thursday 20 October 2011 17:00:13 Kyle Moffett wrote:
> +	return phy_driver_register_multiple(bcm63xx_drivers,
> +			ARRAY_SIZE(bcm63xx_drivers));

if only the arm ARRAY_AND_SIZE() macro could gain traction in the wider tree:
	return phy_driver_register_multiple(ARRAY_AND_SIZE(bcm63xx_drivers));

ignoring that, this patch looks cool

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--nextPart2518635.yaTGvqVo4f
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOoI+OAAoJEEFjO5/oN/WBsHMP/jZTwb5Xeq8jBajesYQifnXR
0D8NsclNkel6sI7JcvWaMc8LwPQAjauwG5LY3bCD/meJE/WijKcnpYzbppMkKlBB
9oJgMJzINdzOQG6S2zMiMPF6uyfvBrVrh/6KAS/LRH9WebGjQGWcT3yGaZHt6F0J
rnFsEh3Qj4TM5hFjjrWQucDSePBfSYA4xe/dmG7O35NR0R/PyZ/VZdtXTRHLoRiS
icg+nKxMZ1/Xa6rDugCXdbnpCD89wPJzSgZ7TRBJeCSUBR1Ny/MYmtXMLKZlhSxQ
qLiXLYORWZKUlHfiNwSrpnaHA+dJBaEXIBSuI3/aoAkbm5ZuTTlQL5I6cbtenU/a
7R96d6/J+P9k3PJiYL3MLoOTrJyzoQ8UNDmR+NlWOnswuQImJE45jWuBZOm4RDRW
a7K3e8FAmEhl890pOB1dcsQTg4GjIN4UgkOBuyhLtn2VMAe3VHNjSssVWdFfQ9Ma
k6kijdVn5pewdAZROBYZlSq9hzcfgluoOTsCgrwARDmfN07xBWkm/gq68/gSvbx4
VVb4A8RMtMsGro3naHky95nNAflbd+5BbsUSZpMdWaBEHyAjjFqBUVqsHrW1dAiN
+4jUOLTwzpAswwKBU2X9LV+Ee5Ztj4hZ/Sg65trK4DQe+2KRNvFpckn9TV2L3WsS
ku8l1lKtCbGH/t/auRru
=hN1g
-----END PGP SIGNATURE-----

--nextPart2518635.yaTGvqVo4f--
