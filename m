Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1I0KZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:25:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33290 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab1I0KZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:25:15 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 0/5] regcache updates
Date: Tue, 27 Sep 2011 11:25:03 +0100
Message-Id: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various regcache updates.  This patch series has only been build
tested on my machine so any testers are highly appreciated.

Dimitris Papastamos (5):
  regmap: Fix signed/unsigned comparison
  regmap: Implement regcache_cache_bypass helper function
  regmap: Implement generic syncing functionality
  regmap: Remove redundant member `word_size' from regcache_rbtree_node
  regmap: Ensure we scream if we enable cache bypass/only at the same
    time

 drivers/base/regmap/regcache-indexed.c |    2 +-
 drivers/base/regmap/regcache-rbtree.c  |   53 +++++++++++++++++-------------
 drivers/base/regmap/regcache.c         |   54 +++++++++++++++++++++++++++----
 include/linux/regmap.h                 |    1 +
 4 files changed, 79 insertions(+), 31 deletions(-)

-- 
1.7.6.4

