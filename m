Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1KXRUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 12:20:44 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47900 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab1KXRUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 12:20:43 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 3/8] firmware: Sigma: Fix endianess issues
Date: Thu, 24 Nov 2011 12:20:51 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com, stable@kernel.org
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <1322138908-32127-3-git-send-email-lars@metafoo.de>
In-Reply-To: <1322138908-32127-3-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4641843.cmqMq6Ze1z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111241220.53832.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4641843.cmqMq6Ze1z
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Thursday 24 November 2011 07:48:22 Lars-Peter Clausen wrote:
> Currently the SigmaDSP firmware loader only works correctly on
> little-endian systems. Fix this by using the proper endianess conversion
> functions.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--nextPart4641843.cmqMq6Ze1z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOznz1AAoJEEFjO5/oN/WBtPMQAI+/gQ/lAUBwV5ga+H5s4EWa
PIQSJhH2G9wLZTs1ajVQYSRd8mYTDEqZ0DpOavX/WCwFV6aUbHQS1RLIcjsB0y61
kzH4IRMhGOAoy2nCUmtH7feADiRfdLUHZr6OPsZ2T6rdKF7QBRXgft19p9tfol8p
XXo7jwH2D5PtYSKQzOW+Cn4g+Zb0oWD6OeB9MPea55VC/4Wfn40Rf6UZ9U9vpXsG
ELgpWiuTtDHvgvKWuPIXBOIQfY8UmCqUpyqUgclHUfnCX8FbHBqP1ut+CLV9/dGg
SsNnkKg25bInzBtCWzIhBsmPuP0iFTbqHkZOyDtd8qrhwFpYx0dqgju+YXnRidZo
oU3CP8RPSrWmgT6DecSYMgOk2n5m3uPkr/3G0lEkdw4kLcPfjXyjfEMrYpxp7Agn
vr2EgCHu4izVGnylw5TX4SbbMDHbIbZLSGTkrJDtDshpntQym/lTg3+3mZHT5nqc
Fu6VL1MRANcVgTKXJ7u21c0nXtPDSTO1hx7XzQbzVlVwINbLvXdMgZ6rcP4w/AFp
ysAFewzRW7gGmCAbXuQeBeJxsQL3A4AScIlaQsezgv5alTHQyx4t+Pv6aQ9cXsd4
XoWvFc50OVHouyqeUErBLjohMka778FxzOHN7L/ZzuXcN037owevlSJH7SI6I+1z
QswGf4PmJLME3r+YaAC/
=1VEp
-----END PGP SIGNATURE-----

--nextPart4641843.cmqMq6Ze1z--
