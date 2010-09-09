Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab0IIWbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:31:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48162 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab0IIW3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rlhEW7V4adqkRThJZvIknd0+wRNX+rBG5Yi75rLIj3/fvT6elwyDwFKOrFsQvrpy/l
         AmqihT305vMMHJUJS+gPZTB5v8iMWzfVJigSTD9cISMswJZPfgi5YErm2pETTHUZsxkY
         T+jeya0O0tX4xRarof9Bt5MXOIhMStbJIfwFI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 089/223]drivers/net/sundance.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:29:33 -0700
Message-Id: <1284071374-7867-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
References: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/sundance.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/sundance.c b/drivers/net/sundance.c
index 2678588..02bdc27 100644
--- a/drivers/net/sundance.c
+++ b/drivers/net/sundance.c
@@ -15,7 +15,7 @@
 	Annapolis MD 21403
 
 	Support and updates available at
-	http://www.scyld.com/network/sundance.html
+	http://www.penguincomputing.com/	
 	[link no longer provides useful info -jgarzik]
 	Archives of the mailing list are still available at
 	http://www.beowulf.org/pipermail/netdrivers/
@@ -193,8 +193,7 @@ IVb. References
 The Sundance ST201 datasheet, preliminary version.
 The Kendin KS8723 datasheet, preliminary version.
 The ICplus IP100 datasheet, preliminary version.
-http://www.scyld.com/expert/100mbps.html
-http://www.scyld.com/expert/NWay.html
+http://www.penguincomputing.com/
 
 IVc. Errata
 
-- 
1.7.2.1

