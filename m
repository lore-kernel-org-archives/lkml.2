Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1FWGjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:39:05 -0400
Received: from mail.perches.com ([173.55.12.10]:3143 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab1FWGjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:39:02 -0400
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] 8390: Neatening
Date: Wed, 22 Jun 2011 23:38:52 -0700
Message-Id: <cover.1308810463.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some updates requested by Geert Uytterhoeven

Joe Perches (8):
  ariadne: Update style, neaten, restructure to eliminate prototypes
  a2065: Use pr_fmt, pr_<level> and netdev_<level>
  lib8390: Use pr_<level> and netdev_<level>
  lib8390: Indent braces appropriately
  lib8390: Normalize source code spacing
  lib8390: Convert include <asm to include <linux
  lib8390: Remove unnecessary extern
  zorro8390: Restructure and eliminate prototypes

 drivers/net/a2065.c     |  336 ++++++-------
 drivers/net/ariadne.c   | 1267 ++++++++++++++++++++++-------------------------
 drivers/net/lib8390.c   |  285 +++++------
 drivers/net/zorro8390.c |  673 +++++++++++++-------------
 4 files changed, 1220 insertions(+), 1341 deletions(-)

-- 
1.7.6.rc3

