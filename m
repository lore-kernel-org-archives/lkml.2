Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab0IQIZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:25:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63753 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0IQIZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:25:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MWRoEEY302W0TawKCfXHXpGDn22S8OsHXC8VlAQzXE5kI+3HcSiL8dpyYZ6SxNWpiQ
         bnegaatfiSFv3pNDukMTFbNpbYRrU9CTH2hGz7WsY5jh29esXPBh5zRGmSQGwOYZPxxg
         R66iLMe9q22JCsAokFx1bwjl/jFDIGWLIFsvY=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 6/9] staging: rt2870: '&pointer[0]' to 'pointer' fix
Date: Fri, 17 Sep 2010 11:24:48 +0300
Message-Id: <1faa8737a2dfae817ea818d8567c1d2f3563fc78.1284711623.git.andy.shevchenko@gmail.com>
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
 drivers/staging/rt2870/common/rtusb_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2870/common/rtusb_io.c b/drivers/staging/rt2870/common/rtusb_io.c
index eb01c8a..7d2f7e0 100644
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -1882,7 +1882,7 @@ void CMDHandler(struct rt_rtmp_adapter *pAd)
 						("UpdateRxWCIDTable(): Aid=%d, "
 							"Addr=%pM!\n",
 							pEntry->Aid,
-							&pEntry->Addr[0]));
+							pEntry->Addr));
 				}
 				break;
 
-- 
1.7.2.2

