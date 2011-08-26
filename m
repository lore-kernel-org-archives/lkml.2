Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1HZI4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:56:50 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:59897 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754425Ab1HZI4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:56:46 -0400
From: Joe Perches <joe@perches.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ath: Reduce logging message code size
Date: Fri, 26 Aug 2011 01:56:37 -0700
Message-Id: <cover.1314347556.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces size ~5KB in an allyesconfig.

Joe Perches (2):
  ath: Make ath_dbg void not int
  ath: Make ath_printk void not int and remove unused struct ath_common *

 drivers/net/wireless/ath/ath.h  |   48 +++++++++++++++++++-------------------
 drivers/net/wireless/ath/main.c |    8 +-----
 2 files changed, 26 insertions(+), 30 deletions(-)

-- 
1.7.6.405.gc1be0

