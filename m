Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1LBJi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:38:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:29779 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1LBJix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:38:53 -0500
X-AuditID: cbfee61a-b7b62ae0000030b0-8f-4ed89cac5f8a
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dh.han@samsung.com
Subject: [PATCH v2 0/2] mmc: core: Support packed command feature of eMMC4.5
Date: Fri, 02 Dec 2011 18:38:51 +0900
Message-id: <003301ccb0d6$338c3ba0$9aa4b2e0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acyw1jL2ZGtcsMnrQmC3A11rJYTbgw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds support of packed command feature
for eMMC4.5 devices.

Changes in v2:
	- Fixed the packed read sequence and error handling.
	- Applied checking the exception status for all cases with
	   the comments from Maya Erez and Sahitya Tummala.
	- Fixed preparing the packed list with the comment from Maya Erez and Venkatraman.

Seungwon Jeon (2):
      mmc: core: Add packed command feature of eMMC4.5
      mmc: core: Support packed command for eMMC4.5 device

 drivers/mmc/card/block.c   |  454 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/mmc/card/queue.c   |   48 +++++-
 drivers/mmc/card/queue.h   |   13 ++
 drivers/mmc/core/mmc.c     |   24 +++
 drivers/mmc/core/mmc_ops.c |    1 +
 include/linux/mmc/card.h   |    3 +
 include/linux/mmc/core.h   |    3 +
 include/linux/mmc/host.h   |    1 +
 include/linux/mmc/mmc.h    |   15 ++
 9 files changed, 538 insertions(+), 24 deletions(-)

Best regards,
Seungwon Jeon.
--
1.7.2.3


