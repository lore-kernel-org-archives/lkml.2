Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab0GUE41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:56:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36891 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762196Ab0GUEzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rBDecVv0dE5Fmt4csK2ChUtRt1uxMw8jk4GxKXUJUYC+kZT54PT2QwKyQEcF2uDz0i
         q2cKxL+cHE8Rotl0ES4EUna1kniBPrnYFXdOE5cO7vlGnItr97+SJnwxhf4jGmiA8rV/
         GLjkIt7q6SSIYZN+3V9R4+Y/3rcUThw/YTgds=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 73/73]Documentation/networking/bonding.txt update web address.
Date: Tue, 20 Jul 2010 21:54:54 -0700
Message-Id: <1279688096-29519-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes a broken web address, and updates 
one to the best of my knowledge.(note:not sure if this is correct).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/bonding.txt |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/bonding.txt b/Documentation/networking/bonding.txt
index 61f516b..c132902 100644
--- a/Documentation/networking/bonding.txt
+++ b/Documentation/networking/bonding.txt
@@ -2431,10 +2431,7 @@ be found at:
 
 https://lists.sourceforge.net/lists/listinfo/bonding-devel
 
-Donald Becker's Ethernet Drivers and diag programs may be found at :
- - http://www.scyld.com/network/
-
 You will also find a lot of information regarding Ethernet, NWay, MII,
-etc. at www.scyld.com.
+etc. at http://www.scyld.com/
 
 -- END --
-- 
1.7.1.rc1.21.gf3bd6

