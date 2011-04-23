Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1DWD0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 23:26:40 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:54074 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753710Ab1DWD0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 23:26:38 -0400
Date: Sat, 23 Apr 2011 05:17:25 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: AT91 pull request
Message-ID: <20110423031725.GE23775@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5109896727722240826
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	This is bug fixes and one old patch that just add the 5series chip id only
	needed by drivers
	the soc full support will be delayed until the current work on the cleannup
	of at91 will be weel advanced

	Could you pull

The following changes since commit 0f1d9f78ce41a8874d30271ef8480e6f8f7f1fce:

  Merge branch 'tty-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6 (2011-04-22 16:19:19 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-2.6-at91.git for-linus

Greg Ungerer (2):
      arm: at91: minimal defconfig for at91x40 SoC
      arm: at91: fix compiler warning for eb01 board build

Jean-Christophe PLAGNIOL-VILLARD (1):
      at91: Add ARCH_ID and basic cpu macros definition for 5series chips family.

Uwe Kleine-König (1):
      ARM: at91: AT91CAP9 has a macb device

 arch/arm/configs/at91x40_defconfig    |   48 +++++++++++++++++++++++++++++++++
 arch/arm/mach-at91/Kconfig            |    1 +
 arch/arm/mach-at91/board-eb01.c       |    7 ++++-
 arch/arm/mach-at91/include/mach/cpu.h |   28 +++++++++++++++++++
 4 files changed, 83 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/configs/at91x40_defconfig

Best Regards,
J & nico.
