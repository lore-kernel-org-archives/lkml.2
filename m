Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187Ab0EURLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:11:17 -0400
Received: from bamako.nerim.net ([62.4.17.28]:56566 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934113Ab0EURLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:11:10 -0400
Date: Fri, 21 May 2010 19:11:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.35, round 1
Message-ID: <20100521191106.5b62529a@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a first round of i2c subsystem updates for Linux 2.6.35
from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

Random fixes and cleanups in many drivers, with a focus on the i2c-i801
and at24 drivers.

 Documentation/i2c/busses/i2c-i801      |    8 +++-
 drivers/i2c/algos/i2c-algo-pca.c       |   36 ++++++------
 drivers/i2c/busses/i2c-ali1535.c       |    2 +-
 drivers/i2c/busses/i2c-ali15x3.c       |    2 +-
 drivers/i2c/busses/i2c-amd756.c        |    2 +-
 drivers/i2c/busses/i2c-amd8111.c       |    2 +-
 drivers/i2c/busses/i2c-at91.c          |    3 +-
 drivers/i2c/busses/i2c-elektor.c       |    2 +-
 drivers/i2c/busses/i2c-gpio.c          |    2 +-
 drivers/i2c/busses/i2c-hydra.c         |    2 +-
 drivers/i2c/busses/i2c-i801.c          |   59 +++++++++++++--------
 drivers/i2c/busses/i2c-ibm_iic.c       |    2 +-
 drivers/i2c/busses/i2c-iop3xx.c        |    3 +-
 drivers/i2c/busses/i2c-mv64xxx.c       |    3 +-
 drivers/i2c/busses/i2c-nforce2.c       |   12 ++---
 drivers/i2c/busses/i2c-ocores.c        |    2 +-
 drivers/i2c/busses/i2c-parport-light.c |    2 +-
 drivers/i2c/busses/i2c-parport.c       |    2 +-
 drivers/i2c/busses/i2c-pasemi.c        |    2 +-
 drivers/i2c/busses/i2c-pca-isa.c       |    2 +-
 drivers/i2c/busses/i2c-pca-platform.c  |    2 +-
 drivers/i2c/busses/i2c-piix4.c         |    2 +-
 drivers/i2c/busses/i2c-pmcmsp.c        |    2 +-
 drivers/i2c/busses/i2c-pxa.c           |    2 +-
 drivers/i2c/busses/i2c-s3c2410.c       |    2 +-
 drivers/i2c/busses/i2c-s6000.c         |    2 +-
 drivers/i2c/busses/i2c-sh7760.c        |    2 +-
 drivers/i2c/busses/i2c-sibyte.c        |    2 +-
 drivers/i2c/busses/i2c-simtec.c        |    3 +-
 drivers/i2c/busses/i2c-sis5595.c       |    2 +-
 drivers/i2c/busses/i2c-sis630.c        |    2 +-
 drivers/i2c/busses/i2c-sis96x.c        |    2 +-
 drivers/i2c/busses/i2c-stub.c          |    9 ++--
 drivers/i2c/busses/i2c-versatile.c     |    3 +-
 drivers/i2c/busses/i2c-via.c           |    2 +-
 drivers/i2c/busses/i2c-viapro.c        |    2 +-
 drivers/i2c/busses/scx200_acb.c        |    4 +-
 drivers/i2c/busses/scx200_i2c.c        |    2 +-
 drivers/i2c/i2c-core.c                 |   90 ++++++++++++++++----------------
 drivers/i2c/i2c-dev.c                  |   36 ++++++------
 drivers/misc/eeprom/at24.c             |   59 +++++++++++++++++----
 41 files changed, 216 insertions(+), 166 deletions(-)

---------------

Chase Douglas (1):
      i2c-nforce2: Remove redundant error messages on ACPI conflict

Farid Hammane (3):
      i2c-core: Fix some coding style issues
      i2c-dev: Fix all coding style issues
      i2c-algo-pca: Fix coding style issues

H Hartley Sweeten (2):
      i2c-dev: Remove unnecessary casts
      i2c: Use <linux/io.h> instead of <asm/io.h>

Ivo Manca (1):
      i2c-i801: Fix all checkpatch warnings

Jean Delvare (6):
      i2c-i801: Let the user disable selected driver features
      i2c-i801: All newer devices have all the optional features
      i2c/scx200_acb: Make PCI device ids constant
      i2c-stub: Expose the default functionality flags
      at24: Fall back to byte or word reads if needed
      i2c-parport: Make template structure const

Marek Szyprowski (1):
      i2c-gpio: Move initialization code to subsys_initcall()

Thanks,
-- 
Jean Delvare
