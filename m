Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0IQI0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:26:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33365 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab0IQIZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=stz7jMrzL8jwHNatHlvzbWFwA1RkzmGVqlWQYwV+N0LMA/pVnO8Ji4x9JLmhuZ0UqG
         TFb21ufEB5qazcWgyBSLKLAL2JbX5RH6pmyeQfIMADOPOQlwN5zoUdosQpV8tD+9jf8Q
         MeEjKQJnOU82j6cLyxXl9bBZnmqTHWaSIlSnk=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 4/9] staging: octeon: '&pointer[0]' to 'pointer' fix
Date: Fri, 17 Sep 2010 11:24:46 +0300
Message-Id: <cc4539d5f7ac7a8a4835b51308787d106403bed7.1284711623.git.andy.shevchenko@gmail.com>
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
 drivers/staging/octeon/ethernet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 9537ea4..fb568a9 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -465,7 +465,7 @@ int cvm_oct_common_init(struct net_device *dev)
 
 	if (cvm_oct_mac_addr_offset >= octeon_bootinfo->mac_addr_count)
 		printk(KERN_DEBUG "%s: Using MAC outside of the assigned range:"
-			" %pM\n", dev->name, &sa.sa_data[0]);
+			" %pM\n", dev->name, sa.sa_data);
 	cvm_oct_mac_addr_offset++;
 
 	/*
-- 
1.7.2.2

