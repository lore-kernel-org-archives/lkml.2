Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1DDJdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:33:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34068 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1DDJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:33:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U2VHDPA7q+a/94pWj34k+Yal3jaIu8duTH8OwFmg9+DCulCRmO7UVGUouQO2J2Znen
         BQgxVzbD3D7NQGqPt04XOr0P7buj3o5w4Jg46BUUDHGIdREuakv9B2gsdL6jLcFwPZ88
         JSk4Mv5HpuZtdTE4nhYIda0Z9mv71RMqvqfog=
From: wanlong.gao@gmail.com
To: linux@dominikbrodowski.net, davem@davemloft.net, padovan@profusion.mobi,
        joe@perches.com, marcel@holtmann.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] X86:NET:Replaced a deprecated function .
Date: Mon,  4 Apr 2011 17:32:28 +0800
Message-Id: <1301909548-20031-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

kernel_warning: pcmcia_request_exclusive_irq is deprecated .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/net/pcmcia/nmclan_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/pcmcia/nmclan_cs.c b/drivers/net/pcmcia/nmclan_cs.c
index 76683d9..bf97231
--- a/drivers/net/pcmcia/nmclan_cs.c
+++ b/drivers/net/pcmcia/nmclan_cs.c
@@ -625,7 +625,7 @@ static int nmclan_config(struct pcmcia_device *link)
   ret = pcmcia_request_io(link);
   if (ret)
 	  goto failed;
-  ret = pcmcia_request_exclusive_irq(link, mace_interrupt);
+  ret = __pcmcia_request_exclusive_irq(link, mace_interrupt);
   if (ret)
 	  goto failed;
   ret = pcmcia_enable_device(link);
-- 
1.7.3

