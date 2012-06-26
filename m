Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2FZMEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 08:04:06 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:8227
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112Ab2FZMEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 08:04:05 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT001.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzzz2fh2a8h668h839hd24he5bhf0ah)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] staging: ozwpan: Update TODO & fixes 
Date: Tue, 26 Jun 2012 13:03:38 +0100
Message-ID: <1340712221-6750-1-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch patch series updates TODO & fixes issues found during development.

Rupesh Gujare (3):
	[PATCH 1/3] staging: ozwpan: Unregister with sysfs while unloading.
	[PATCH 2/3] staging: ozwpan: Fix compilation issue due to export.h
	[PATCH 3/3] staging: ozwpan: Update TODO file

	drivers/staging/ozwpan/TODO     |   11 ++++++-----
	drivers/staging/ozwpan/ozcdev.c |   12 ++++++++----
	drivers/staging/ozwpan/ozhcd.c  |    2 +-
	3 files changed, 15 insertions(+), 10 deletions(-)

