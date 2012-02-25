Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2BYRRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 12:17:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57872 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab2BYRRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 12:17:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of larry.finger@gmail.com designates 10.42.235.137 as permitted sender) smtp.mail=larry.finger@gmail.com; dkim=pass header.i=larry.finger@gmail.com
From: Larry Finger <Larry.Finger@lwfinger.net>
To: gregkh@linuxfoundation.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 0/2] staging: r8712u: Fix two regressions
Date: Sat, 25 Feb 2012 11:17:13 -0600
Message-Id: <1330190235-511-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes regressions introduced in kernel 3.2.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Larry Finger (2):
  staging: r8712u: Fix regression introduced by commit a5ee652
  staging: r8712u: Fix regression caused by commit 8c213fa

 drivers/staging/rtl8712/os_intfs.c |    5 -----
 drivers/staging/rtl8712/usb_intf.c |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.7.7

