Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1LVUUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:20:24 -0500
Received: from havoc.gtf.org ([69.61.125.42]:34894 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab1LVUUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:20:19 -0500
Date: Thu, 22 Dec 2011 15:20:17 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata build fix for 3.2-rc
Message-ID: <20111222202017.GA13208@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A sparc build fix...


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Please pull 19d40dcabf1cdf84e1a76c147b7177b5a6c21943 from
git://github.com/jgarzik/libata-dev.git upstream-linus

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTvOQqCWzCDIBeCsvAQJRiw//bqZDQFOcfpwPpY3P1Frimer5UbZALGDd
8sIYctAKDz1OfgH1e1Sm7lvoJKcmBl0U4QNgp7SkiT9QfOZCg81Cw9ZyJCUQE2F7
sqGBBP1Pg+3qsCTYZY4aqcd2skfrKvX3KX+fapW7+C8WriAgwvyYzyLqyCcYu7hf
g3J6tmTMPdGyppUj/1yRJbGqrIorc+jtKHQoO7ASYGAe0eLWCFMA4o6ml25af1OF
z62AuKpY0RzNTYcBtzYdipHUBX4ZNyhKkGK68x+m2vnbIIDYTlAsqW/9tiLEfSdt
sKBknSx3O3z6zb+EZpO5xXax6ED2YnGsHlj9k49sZ/hCuhOErUUGvU8b9nJW/xkM
j2meZBWQSu5ceJuZCbq94Qe5VKY4YCmmge6xpHsoEuwXDPbZfGjpM93ePwlSyKtr
wtxLkIKuZQIqGYieY5+sVSXyp2/H76p6Pyp4XSCrEAxKW0IlaPQNr5VrroF+i2bE
uua/41WHoIBFdlS0rU5hkXo6nSSCVFUXZa5nT2xFoxsBYr/iP10WmuHQz4A77ocp
cTUDC5dB4n4zy0TLbOm7MKHQ5YPh68cqySwM8FLlj4uaea2aKAZqFq2Lfuw/acLA
ngsffDOTpSyKc8lp/fwUIQ9no3pCvsHOwaDDKEsV6LT8RQ1GHfEjF1RHPMgpi35A
bKhObdycgnU=
=flSW
-----END PGP SIGNATURE-----

to receive the following updates:

 drivers/ata/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

David Miller (1):
      pata_of_platform: Add missing CONFIG_OF_IRQ dependency.

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 6bdedd7..cf047c4 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -820,7 +820,7 @@ config PATA_PLATFORM
 
 config PATA_OF_PLATFORM
 	tristate "OpenFirmware platform device PATA support"
-	depends on PATA_PLATFORM && OF
+	depends on PATA_PLATFORM && OF && OF_IRQ
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems with OpenFirmware
