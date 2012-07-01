Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2GASBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:01:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50060 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab2GASBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:01:49 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Meyer <thomas@m3y3r.de>, Jiri Kosina <jkosina@suse.cz>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/ft1000: fix minor coding style problem
Date: Sun,  1 Jul 2012 23:31:35 +0530
Message-Id: <1341165695-32680-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this following warn is fixed up

drivers/staging/ft1000/ft1000-usb/ft1000_hw.c:1754:
ERROR: open brace '{' following function declarations go on the next line

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index c1f4f13..31929ef 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1751,8 +1751,8 @@ out:
 	return status;
 }
 
-int ft1000_poll(void* dev_id) {
-
+int ft1000_poll(void* dev_id)
+{
     struct ft1000_device *dev = (struct ft1000_device *)dev_id;
 	struct ft1000_info *info = netdev_priv(dev->net);
 
-- 
1.7.9.5

