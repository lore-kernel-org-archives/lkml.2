Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1HRIU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:20:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38613 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab1HRIUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:20:23 -0400
X-AuditID: cbfee61b-b7b7fae000005864-e1-4e4ccb45da21
Date: Thu, 18 Aug 2011 17:20:18 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 0/2] RTC-S3C Update
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        Changhwan Youn <chaos.youn@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Message-id: <1313655620-1046-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 18 Aug 2011 08:21:03.0704 (UTC)
 FILETIME=[C52AAD80:01CC5D7F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1/2: Bugfix: correct debugs messages
2/2: Allow multiple RTC open and IRQ handling w/o IOCTL.

MyungJoo Ham (2):
  rtc: rtc-s3c: Correct debug messages.
  rtc: rtc-s3c: Allow multiple open / allow no-ioctl-open'ed rtc to
    have irq.

 drivers/rtc/rtc-s3c.c |   79 +++++++++++++++++++-----------------------------
 1 files changed, 31 insertions(+), 48 deletions(-)

-- 
1.7.4.1

