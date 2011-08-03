Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1HCLr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 07:47:56 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45591 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1HCLru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 07:47:50 -0400
Subject: [PATCH] block: swim3: fix unterminated of_device_id table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Aug 2011 19:47:41 +0800
Message-ID: <1312372061.2788.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_device_id structures need a NULL terminating entry, add it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/block/swim3.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 773bfa7..ae3e167 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1184,6 +1184,7 @@ static struct of_device_id swim3_match[] =
 	{
 	.compatible	= "swim3"
 	},
+	{ /* end of list */ }
 };
 
 static struct macio_driver swim3_driver =
-- 
1.7.4.1



