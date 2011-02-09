Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab1BIOEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:04:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36706 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1BIOCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:02:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=LjHOqVabzS9u8/BpLdWHY4Wdjln4Rh2c3FcZBPPL0pUBtP/vCrxa2DIsRffzNFE3u1
         fGNEIKNF+5I+tgLrLSwHRluJxrljv58dZ2kuPVv9goo9QpLIIKAE2jXGBVi8RfLVZYUh
         CIBPPzAEwtahRfvJatyBUJ7i9iDsRSuOW+cR8=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/9] staging: ft1000: Remove unused header ft1000_hw.h
Date: Wed,  9 Feb 2011 15:02:35 +0100
Message-Id: <1297260162-19263-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
References: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)
 delete mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_hw.h

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h
deleted file mode 100644
index ab9312f..0000000
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h
+++ /dev/null
@@ -1,10 +0,0 @@
-
-#ifndef _FT1000_HW_H_
-#define _FT1000_HW_H_
-
-#include "ft1000_usb.h"
-
-extern u16 ft1000_read_register(struct usb_device *dev, u16 *Data, u8 nRegIndx);
-extern u16 ft1000_write_register(struct usb_device *dev, u16 value, u8 nRegIndx);
-
-#endif
-- 
1.7.1

