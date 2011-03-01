Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1CAFER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:04:17 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:46174 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1CAFEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:04:14 -0500
X-ASG-Debug-ID: 1298955853-082e62f20001-xx1T2L
X-Barracuda-Envelope-From: bzhao@marvell.com
From: Bing Zhao <bzhao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>, Frank Huang <frankh@marvell.com>,
        Bing Zhao <bzhao@marvell.com>
X-ASG-Orig-Subj: [RFC v2 0/2] hexdump dynamic debug
Subject: [RFC v2 0/2] hexdump dynamic debug
Date: Mon, 28 Feb 2011 21:06:54 -0800
X-ASG-Orig-Subj: [RFC v2 0/2] hexdump dynamic debug
Message-Id: <1298956016-30673-1-git-send-email-bzhao@marvell.com>
X-Mailer: git-send-email 1.7.0.2
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1298955853
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds hexdump macros utilizing dynamic debug.

v2: rebase against linux-next.git tree and split into 2 patches

Bing Zhao (2):
  dynamic debug: add dynamic_hexdump_debug macro
  printk: add hexdump_debug macro

 include/linux/dynamic_debug.h |   22 ++++++++++++++++++++++
 include/linux/printk.h        |   14 ++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

