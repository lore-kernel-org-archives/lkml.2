Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0CaGai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:30:38 -0400
Received: from helios.rbi.informatik.uni-frankfurt.de ([141.2.1.4]:48534 "EHLO
	helios.rbi.informatik.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932744Ab0CaGa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:30:29 -0400
X-Greylist: delayed 5760 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2010 02:30:29 EDT
Date: Wed, 31 Mar 2010 06:54:14 +0200
From: Martin Teufel <teufel@informatik.uni-frankfurt.de>
To: linux-kernel@vger.kernel.org
Subject: AMD Geode LX WDT (geode-mfgpt)
Message-ID: <20100331045414.GA3241@hekate.rbi.informatik.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

I have some ALIX boards (SBC) with AMD Geode LX CPUs and their companion
device CS5536 and am using Debian on them. I didn't care about the
integrated watchdog timer (in the CS5536) so far. Recently I did, but
neither the CONFIG_GEODE_WDT was set in the debian kernel (2.6.26), nor
the CONFIG_GEODE_MFGPT_TIMER. So I compiled my own debian 2.6.26 geode
kernel (CONFIG_MGEODE_LX=y, CONFIG_GEODE_WDT=y,
CONFIG_GEODE_MFGPT_TIMER=y, CONFIG_CRYPTO_DEV_GEODE=y etc.).

My problem is that the geode-mfgpt doesn't find any timers:

[    0.204012] geode-mfgpt:  0 MFGPT timers available.
[    0.208013] mfgpt-timer:  Could not allocate a MFPGT timer
...
[    2.284029] geodewdt:  No timers were available

My question is: Why doesn't it? Is this a known bug? If so, is it
already fixed in a newer kernel version?

BTW: There are two typing errors in the mfgpt_32.c (line 232 and 342).
It should be MFGPT but is MFPGT. :)

Please note that I'm *not* on the mailing list, so please send me a CC
of your answer(s) - thanks.
Since I'm relatively new to kernel issues maybe I'm just missing
something. If so, please forgive me and don't objurgate me too much. ;-)

Regards,
Martin

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLstV2OHuQTha1HuYRAlN5AJ9MQoYuyY7pwyQczJdlpC6BvTwz0wCeJ5Ah
UFS4QXHAoTVP7llcaGWstLQ=
=yDBf
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
