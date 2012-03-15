Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161246Ab2COXdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:33:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50441 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031170Ab2COXdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:33:42 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 0/2] Cleaned up comments
Date: Thu, 15 Mar 2012 19:32:06 -0400
Message-Id: <1331854328-21794-1-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed some old comments and realigned others.
Everything else looks pretty good.

Andrew Miller (2):
  Staging: rtl8187se: r8180_wx.c: Removed old comments
  Staging: rtl8187se: r8180_wx.c: Cleaned up comments

 drivers/staging/rtl8187se/r8180_wx.c |  286 +++++++--------------------------
 1 files changed, 61 insertions(+), 225 deletions(-)

-- 
1.7.7.6

