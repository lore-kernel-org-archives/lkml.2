Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab1KSPDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 10:03:20 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:51141 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1KSPDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 10:03:19 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 00/16] DocG3 fixes and write support
Date: Sat, 19 Nov 2011 16:02:42 +0100
Message-Id: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem and David,

This patchset has been in review for several weeks. All
pending comments have been handled. I'd like to have it in
for the next merge window. Do I need to do anything else to
have it integrated (grouping patches to have lesser kernel
history impact, ...) ?

Cheers.

--
Robert

This patchset is aimed at :
 - fixing 5 glitches in the driver
 - add several new functions

The added functions are :
 - add block erase capability
 - add write page capability
 - add powerdown and powerup
 - add multiple floor support
 - add ECC support
 - add docg3 modes support
 - add protection support (DPS areas)


Robert Jarzmik (16):
  mtd/docg3: fix debug log verbosity
  mtd/docg3: fix tracing of IO in writeb
  mtd/docg3: fix protection areas reading
  mtd/docg3: fix BCH registers
  mtd/docg3: fix reading oob+data without correction
  mtd/docg3: add multiple floor support
  mtd/docg3: add OOB layout to mtdinfo
  mtd/docg3: add registers for erasing and writing
  mtd/docg3: add OOB buffer to device structure
  mtd/docg3: add write functions
  mtd/docg3: add erase functions
  mtd/docg3: map erase and write functions
  mtd/docg3: add ECC correction code
  mtd/docg3: add suspend and resume
  mtd/docg3: add fast mode
  mtd/docg3: add protection areas sysfs access

 drivers/mtd/devices/Kconfig |    9 +
 drivers/mtd/devices/docg3.c | 1451 ++++++++++++++++++++++++++++++++++++-------
 drivers/mtd/devices/docg3.h |   64 ++-
 3 files changed, 1299 insertions(+), 225 deletions(-)

-- 
1.7.5.4

