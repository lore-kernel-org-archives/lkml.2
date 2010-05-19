Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0ESXXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 19:23:34 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:22824 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751760Ab0ESXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 19:23:32 -0400
Date: Thu, 20 May 2010 00:23:27 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: torvalds@linux-foundation.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Please pull bjdooks' for-linus/i2c-2635 tree
Message-ID: <20100519232327.GA5024@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following tree:

The following changes since commit 024a6b95181f2df6090975c8a293499d24bf8b28:
  Linus Torvalds (1):
        Merge branch 'davinci-for-linus' of git://git.kernel.org/.../khilman/linux-davinci

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git for-linus/i2c-2635

Alexander Shishkin (2):
      omap: i2c: make errata 1.153 workaround a separate function
      omap: i2c: add a timeout to the busy waiting

Kalle Jokiniemi (1):
      i2c-omap: add mpu wake up latency constraint in i2c

Mark Brown (1):
      i2c-s3c2410: Remove unconditional 1ms delay on each transfer

Michael Hennerich (1):
      i2c-bfin-twi: add debug output for error status

Rabin Vincent (2):
      i2c-nomadik: release region when removed
      i2c-nomadik: fix operator precedence warning

Santosh Shilimkar (1):
      omap: i2c: Add i2c support on omap4 platform

Sonic Zhang (4):
      i2c-bfin-twi: integrate timeout timer with completion interface
      i2c-bfin-twi: fix lost interrupts at high speeds
      i2c-bfin-twi: remove redundant retry
      i2c-bfin-twi: return completion in interrupt for smbus quick transfers

Uwe Kleine-König (2):
      i2c-pxa: remove unused macro
      MAINTAINERS: add i2c tree for embedded platforms

Wolfram Sang (5):
      i2c-pxa: only define 'blue_murder'-function if DEBUG is #defined
      i2c-mpc: drop NO_IRQ
      i2c-cpm: drop NO_IRQ
      i2c-ibm-iic: drop NO_IRQ
      i2c-highlander: remover superflous variable

manjugk manjugk (2):
      OMAP2/3: I2C: Errata ID i207: Clear wrong RDR interrupt
      OMAP3: I2C: Clean up Errata 1p153 handling

 MAINTAINERS                         |    1 +
 arch/arm/plat-omap/i2c.c            |   39 ++++--
 drivers/i2c/busses/i2c-bfin-twi.c   |  168 ++++++++++------------
 drivers/i2c/busses/i2c-cpm.c        |    2 +-
 drivers/i2c/busses/i2c-highlander.c |    5 +-
 drivers/i2c/busses/i2c-ibm_iic.c    |   14 +-
 drivers/i2c/busses/i2c-mpc.c        |    6 +-
 drivers/i2c/busses/i2c-nomadik.c    |    6 +-
 drivers/i2c/busses/i2c-omap.c       |  265 +++++++++++++++++++++++++++-------
 drivers/i2c/busses/i2c-pxa.c        |   26 ++--
 drivers/i2c/busses/i2c-s3c2410.c    |   19 +++-
 include/linux/i2c-omap.h            |    9 ++
 12 files changed, 374 insertions(+), 186 deletions(-)
 create mode 100644 include/linux/i2c-omap.h

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
