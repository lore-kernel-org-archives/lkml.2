Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab1AQC2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 21:28:15 -0500
Received: from helios.rbi.informatik.uni-frankfurt.de ([141.2.1.4]:47744 "EHLO
	helios.rbi.informatik.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253Ab1AQC2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 21:28:13 -0500
X-Greylist: delayed 6839 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Jan 2011 21:28:13 EST
Date: Mon, 17 Jan 2011 01:34:11 +0100
From: Martin Teufel <teufel@informatik.uni-frankfurt.de>
To: linux-kernel@vger.kernel.org
Subject: Do GEODE_MFGPT_TIMER and GEODE_WDT really depend on MGEODE_LX?
Message-ID: <20110117003411.GA27646@hekate.rbi.informatik.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

since a few days I am running my own debian 2.6.32-5 on my ALIX machines
and the watchdogs (GEODE_MFGPT_TIMER, GEODE_WDT) are running and doing a
good job. Now I thought about an upstream solution for the debian stock
kernel but therefore need to know if GEODE_MFGPT_TIMER and GEODE_WDT
really depend on MGEODE_LX, as the Linux kernel configuration points
out.
In other words: Is it possible to compile a kernel with these drivers
which is not Geode LX specific (where MGEODE_LX is not set) and/or is it
possible to add these modules later by module-assistant (to a kernel
where MGEODE_LX is not set)?

Please note that I'm *not* on the mailing list, so please send me a CC
of your answer(s) - thanks.

Best regards,
Martin

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0zjoMACgkQK1fQl8zzxa5/bwCfRBHfb/dASOIoj4PPp3zmBCoP
uqcAn0BWeBtbmM24PkQS5h3/vRwgM9U3
=Scey
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
