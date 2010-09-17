Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0IQIZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:25:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63415 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab0IQIZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tqHhzJ9P3X5DUlvekCxSwpHVMAyx58LfkJOGHWMHlY1OUpO7GQruiGXhvgk0IW3FSs
         IhMkrQ4KApCRzBgJptu4b4DfGSxi7yM2aVNt2bjoxZF2Lk3nVvjCCAMdom5tarx1iclS
         8hC6Rl2vr2XhWXUC4ejyigAhKlsFEwM6YO+nQ=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 9/9] staging: wlags49_h2: '&pointer[0]' to 'pointer' fix
Date: Fri, 17 Sep 2010 11:24:51 +0300
Message-Id: <5c6ea7012f5343cb3617d63c155b8b71b777aee3.1284711623.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20100916225346.GA14448@kroah.com>
References: <20100916225346.GA14448@kroah.com>
In-Reply-To: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
References: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/wlags49_h2/wl_util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_util.c b/drivers/staging/wlags49_h2/wl_util.c
index e510dcb..4521c9f 100644
--- a/drivers/staging/wlags49_h2/wl_util.c
+++ b/drivers/staging/wlags49_h2/wl_util.c
@@ -338,7 +338,7 @@ const char *DbgHwAddr(unsigned char *hwAddr)
     static char     buffer[18];
     /*------------------------------------------------------------------------*/
 
-	sprintf(buffer, "%pM", &hwAddr[0]);
+	sprintf(buffer, "%pM", hwAddr);
 
     return buffer;
 } // DbgHwAddr
-- 
1.7.2.2

