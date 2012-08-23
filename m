Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab2HWOYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:24:49 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:47557 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab2HWOYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:24:47 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2012 10:24:47 EDT
Message-ID: <50363B12.4060009@archlinux.org>
Date: Thu, 23 Aug 2012 16:15:46 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>, Peter Tyser <ptyser@xes-inc.com>,
        Wim Van Sebroeck <wim@iguana.be>, Aaron Sierra <asierra@xes-inc.com>,
        Guenter Roeck <linux@roeck-us.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        Tobias Powalowski <tpowa@archlinux.org>
Subject: Serious regression in 3.5's iTCO_wdt, does anyone care?
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig042C56DF574069BAE902F0B7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig042C56DF574069BAE902F0B7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

This regards the following commit in the Linus tree:

commit 887c8ec7219fc8eba78bb8f44a74c660934e9b98
Author: Aaron Sierra <asierra@xes-inc.com>
Date:   Fri Apr 20 14:14:11 2012 -0500

    watchdog: Convert iTCO_wdt driver to mfd model

Ever since the Linux 3.5 update, the iTCO_wdt driver has been completely
non-functional on every machine I encountered due to the above
conversion. A bug report for this problem has been open at
https://bugzilla.kernel.org/show_bug.cgi?id=3D44991 for over a month.

Yet, neither the author of the commit, nor the people who signed off on
it have reacted to the bug report.

At this point, I believe that none of you are actually aware of the
problem and I write you to change that unfortunate situation.

Regards
Thomas B=E4chler


--------------enig042C56DF574069BAE902F0B7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJQNjsVAAoJEChPw0yOSxolZj0P/1k03l70GyARaCGJySVCbhH+
UPUEgisUDpTYLEbEjHH3zN99YscqqFNvf6Pecfat5mvAR+nxIv/0C5reEy/+4YHs
o9on/LsWI/FOwfDzO23IC7CXyohiiuUCglZ4Qlfx7DvRcQZ7LHQ9Aidnxa0egajo
mOptDlPp5gwcrgfBafITNLPcjWTRw62S8F66NlHc4uTJIDx43Koo26nExglVOzdq
qC0X2MBInEAJ++cNsSjwYFPMRORzP59AJdDNg2SoM+Qnv5Pt07SuJG/SnmJ6NPwF
oSfnjf3rhRzxRwVPvjmYt6GtVUCavou9QalbXgyi6t01DwIGQpvAfIgMUKe/FMa+
qZrJzIu4gYI6CrtyXyhR/XgI0See02Oni9NdUT05RFq85xczbI5rlNcweD9CAL1Y
mSP922TTfbquRuvBSyPYhRMbmAikTWnnyptvqbVioxVilk6WwJWKjOmUy2kmgPKI
xBN4trt3chsZ2+GB5okcZkZl8OblJbhMhg32UKL/WP3lQoPvjKbQ5UWqSee1zZrt
ljdTb/MmccsXYiiDlMA02PvG5ZTjvn2Yeq2NO/qyQYCTIuAkvc+qOoy6fX3qlOYT
z9qy17Jt1mdysRRqsTCkQ4Fm6iNcQiinkIM1Ys/aqzl1KHhb2+hdcxNVLbnP26Wj
ovIpPCMd+bGs/6W5Dgm6
=T/NN
-----END PGP SIGNATURE-----

--------------enig042C56DF574069BAE902F0B7--
