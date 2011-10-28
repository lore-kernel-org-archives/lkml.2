Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1J1RwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:52:08 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:46808 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1J1RwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:52:07 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 00/13]  DocG3 fixes and write support
Date: Fri, 28 Oct 2011 19:51:19 +0200
Message-Id: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is aimed at :
 - fixing 4 glitches in the driver
 - add several new functions

The added functions are :
 - add block erase capability
 - add write page capability
 - add powerdown and powerup
 - add multiple floor support
 - add ECC support

The ECC part should especially be reviewed by Ivan and Mike,
as this is their work (patch "add ECC correction code"). 

Happy review.

--
Robert

Robert Jarzmik (13):
  mtd/docg3: fix debug log verbosity
  mtd/docg3: fix tracing of IO in writeb
  mtd/docg3: fix protection areas reading
  mtd/docg3: fix BCH registers
  mtd/docg3: add multiple floor support
  mtd/docg3: add OOB layout to mtdinfo
  mtd/docg3: add registers for erasing and writing
  mtd/docg3: add OOB buffer to device structure
  mtd/docg3: add write functions
  mtd/docg3: add erase functions
  mtd/docg3: map erase and write functions
  mtd/docg3: add ECC correction code
  mtd/docg3: add suspend and resume

 drivers/mtd/devices/Kconfig |    1 +
 drivers/mtd/devices/docg3.c |  933 +++++++++++++++++++++++++++++++++++++------
 drivers/mtd/devices/docg3.h |   42 ++-
 3 files changed, 860 insertions(+), 116 deletions(-)

-- 
1.7.5.4

