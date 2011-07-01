Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab1GAI1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:27:30 -0400
Received: from 1.98.mail-out.ovh.net ([87.98.188.136]:51702 "EHLO
	98.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755367Ab1GAI11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:27:27 -0400
X-Greylist: delayed 111952 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jul 2011 04:27:27 EDT
Date: Fri, 1 Jul 2011 08:54:11 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: AT91: Fix pull requset
Message-ID: <20110701065411.GD14408@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 8259601717259840314
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Linus, Russell, Arnd

	I do not known who can take this pull request

	But this is some fix for at91 for the 3.0

The following changes since commit 5220cc9382e11ca955ce946ee6a5bac577bb14ff:

  Merge branch 'for-linus' of git://git.kernel.dk/linux-block (2011-06-24 08:42:35 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-2.6-at91.git at91-next

Jean-Christophe PLAGNIOL-VILLARD (3):
      at91: fix at91_set_serial_console: use platform device id
      atmel_serial: fix internal port num
      at91: fix udc, ehci and mmc clock device name for cap9/9g45/9rl

Joachim Eastwood (1):
      at91: Use "pclk" as con_id on at91cap9 and at91rm9200

 arch/arm/mach-at91/at91cap9.c            |    8 ++++----
 arch/arm/mach-at91/at91cap9_devices.c    |    2 +-
 arch/arm/mach-at91/at91rm9200.c          |    6 +++---
 arch/arm/mach-at91/at91rm9200_devices.c  |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9g45.c         |   10 +++++-----
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9rl.c          |    4 ++--
 arch/arm/mach-at91/at91sam9rl_devices.c  |    2 +-
 drivers/tty/serial/atmel_serial.c        |    3 ++-
 12 files changed, 23 insertions(+), 22 deletions(-)

Best Regards,
J.
