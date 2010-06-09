Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab0FITim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:38:42 -0400
Received: from mail.perches.com ([173.55.12.10]:2933 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab0FITil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:41 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] MAINTAINERS: Cleanups after renames/deletions
Date: Wed,  9 Jun 2010 12:38:26 -0700
Message-Id: <cover.1276112117.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some miscellaneous cleanups

Joe Perches (12):
  MAINTAINERS: Update ARM/BCMRING MTD NAND DRIVER file patterns
  MAINTAINERS: Update ARM/NUVOTON W90X900 ARM ARCHITECTURE file patterns
  MAINTAINERS: Update ARM/VOIPAC PXA270 file patterns
  MAINTAINERS: Update ARM/ZIPIT Z2 SUPPORT file patterns
  MAINTAINERS: Update NETWORKING [WIRELESS] file patterns
  MAINTAINERS: Update PPP OVER L2TP file patterns
  MAINTAINERS: Update RICOH SMARTMEDIA/XD DRIVER file patterns
  MAINTAINERS: Remove section SMX UIO Interface
  MAINTAINERS: Update SPEAR CLOCK FRAMEWORK SUPPORT file patterns
  MAINTAINERS: Remove section STRIP
  MAINTAINERS: Remove section WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
  Documentation/networking/wavelan.txt: Deleted, not in tree

 Documentation/networking/wavelan.txt |   73 ----------------------------------
 MAINTAINERS                          |   37 ++++-------------
 2 files changed, 9 insertions(+), 101 deletions(-)
 delete mode 100644 Documentation/networking/wavelan.txt

