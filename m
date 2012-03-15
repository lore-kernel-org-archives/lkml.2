Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081Ab2COTGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:06:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44452 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760860Ab2COTGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:06:49 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 0/5] Staging: rtl8187se: r8180_dm.c: Fix Coding Style issues
Date: Thu, 15 Mar 2012 15:05:16 -0400
Message-Id: <1331838321-18453-1-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes many Coding Style issues in r8180_dm.c

This came out much larger then I thought it was going to,
If this is to much for one patchset, please let me know.

Andrew Miller (5):
  Staging: rtl8187se: r8180_dm.c: Removed spaces before tab stop
  Staging: rtl8187se: r8180_dm.c: Fix brackets
  Staging: rtl8187se: r8180_dm.c: Fixed indentation issues
  Staging: rtl8187se: r8180_dm.c: Fix spacing issues
  Staging: rtl8187se: r8180_dm.c: Fix comments

 drivers/staging/rtl8187se/r8180_dm.c | 2007 +++++++++++++++-------------------
 1 files changed, 892 insertions(+), 1115 deletions(-)

-- 
1.7.7.6

