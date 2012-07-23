Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2GWGu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:50:59 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:8823 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312Ab2GWGu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:50:57 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7LPOR-02-5HO-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lin Ming <minggr@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH 0/5] Fix for ZPODD
Date: Mon, 23 Jul 2012 14:49:35 +0800
Message-ID: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
X-OriginalArrivalTime: 23 Jul 2012 06:50:28.0373 (UTC) FILETIME=[71E7FC50:01CD689F]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some patches to make ZPODD easier to use for end users and
a fix for using ZPODD with system suspend.

Aaron Lu (5):
  scsi: sr: fix for sr suspend and resume
  scsi: sr: runtime pm when ODD is open/closed
  scsi: sr: block events when runtime suspended
  scsi: pm: use runtime resume callback if available
  block: genhd: add an interface to set disk's poll interval

 block/genhd.c          | 25 ++++++++++++++++++------
 drivers/scsi/scsi_pm.c | 14 ++++++++-----
 drivers/scsi/sr.c      | 53 ++++++++++++++++++++++++++++++++++++--------------
 include/linux/genhd.h  |  1 +
 4 files changed, 67 insertions(+), 26 deletions(-)

-- 
1.7.11.3


