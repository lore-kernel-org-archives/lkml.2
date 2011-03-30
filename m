Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1DCQHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 12:07:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49704 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1DCQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 12:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=X0QXeVIAT8pumMwMx9rwoR0ayB7rZtDl9gs1DzJZIL8QNEzCKiZlPXRXdoi1oXYI1W
         PHx4nhnG+1QX0xCtE1H+dJXx6RRJjomGQGdLvFwPnWcZE3zvTKn2r/P1dmZc1x/OyxQr
         zyuFqa/yM7U8PKHU1ITFw76XHZbbJSgyWMb3s=
From: bookjovi@gmail.com
To: bookjovi@gmail.com, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] amba: remove invalid location line in file header
Date: Wed, 30 Mar 2011 05:35:34 -0400
Message-Id: <1301477734-2677-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

remove invalid location line in file header after file moved

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 drivers/amba/bus.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 6d2bb25..539948a 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/arm/common/amba.c
- *
  *  Copyright (C) 2003 Deep Blue Solutions Ltd, All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
-- 
1.7.2.3

