Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2IHX0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 19:26:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59021 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2IHX0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 19:26:03 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 4/5] driver core: remove __must_check on declaration of driver_attach
Date: Sun,  9 Sep 2012 07:25:19 +0800
Message-Id: <1347146720-28596-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
References: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check is not necessary since driver_attach should return 0
always.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 include/linux/device.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 7222c0b..dbb5efd 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -858,7 +858,7 @@ static inline void *dev_get_platdata(const struct device *dev)
 extern int __must_check device_bind_driver(struct device *dev);
 extern void device_release_driver(struct device *dev);
 extern int  __must_check device_attach(struct device *dev);
-extern int __must_check driver_attach(struct device_driver *drv);
+extern int driver_attach(struct device_driver *drv);
 extern int __must_check device_reprobe(struct device *dev);
 
 /*
-- 
1.7.9.5

