Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0IIWg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:36:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48051 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab0IIWgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qOWBM4YXBBZ9oSNY1agwVd+DCip4WU02iTXn30Dw/ecY0DV1PY+WOr9GUCjyU6XV7Y
         VUd4OIUwQbdzEtHnk11WYflorCHKXTa5Ki/OpRhaGW15zM7ccYxgckEfgbHFpSluLP+/
         PX9XGZtM/9ZZGe0Rjcc5IWi3lA2oqkBpIHygI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 118/223]drivers/net/appletalk/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:47 -0700
Message-Id: <1284071809-8149-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
References: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/appletalk/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
index 0a0e0cd..9368cfa 100644
--- a/drivers/net/appletalk/Kconfig
+++ b/drivers/net/appletalk/Kconfig
@@ -10,15 +10,15 @@ config ATALK
 	  wish to connect to it, say Y.  You will need to use the netatalk package
 	  so that your Linux box can act as a print and file server for Macs as
 	  well as access AppleTalk printers.  Check out
-	  <http://www.zettabyte.net/netatalk/> on the WWW for details.
+	  <http://cgi.zettabyte.net/> on the WWW for details.
 	  EtherTalk is the name used for AppleTalk over Ethernet and the
 	  cheaper and slower LocalTalk is AppleTalk over a proprietary Apple
 	  network using serial links.  EtherTalk and LocalTalk are fully
 	  supported by Linux.
 
 	  General information about how to connect Linux, Windows machines and
-	  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.  The
-	  NET-3-HOWTO, available from
+	  Macs is on the WWW at <http://en.wikibooks.org/wiki/Linux_Networking/Appletalk_%28AF_APPLETALK%29>.
+	  The NET-3-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>, contains valuable
 	  information as well.
 
-- 
1.7.2.1

