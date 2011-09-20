Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1ITLZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 07:25:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1ITLZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 07:25:25 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: [PATCH 0/2] ptp: more bug fixes for 3.1 and 3.0
Date: Tue, 20 Sep 2011 13:25:40 +0200
Message-Id: <cover.1316516989.git.richard.cochran@omicron.at>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix two bugs in the PTP Hardware Clock drivers. The
drivers were first introduced in Linux version 3.0.

Thanks,
Richard

Richard Cochran (2):
  ptp: fix L2 event message recognition
  dp83640: reduce driver noise

 drivers/net/phy/dp83640.c    |    4 ++--
 include/linux/ptp_classify.h |   13 ++++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

-- 
1.7.2.5

