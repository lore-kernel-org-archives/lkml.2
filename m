Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab0IKFpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:45:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44991 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab0IKFph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OgjqOr93wjF3d/OwQVLg5E3pBQJMhSm2lYeQC40JF/WMwqbpZIK+TsknKZQXhz+zQt
         qvUtOFd8ARpk2OXEBAZniu7KQcL6zlXefWXCd9sRmLVyjEDyypodNyXQXyNl/nzrFhRA
         l7ndPC2VHVg8PTX1yzv8G7V5VMCIixwa2NCdg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 02/11]net/ipv4/netfilter/Kconfig Update broken web addresses.
Date: Fri, 10 Sep 2010 22:45:54 -0700
Message-Id: <1284183963-8474-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
References: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 net/ipv4/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1833bdb..83731a4 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -147,7 +147,7 @@ config IP_NF_TARGET_ULOG
 	  which can only be viewed through syslog.
 
 	  The appropriate userspace logging daemon (ulogd) may be obtained from
-	  <http://www.gnumonks.org/projects/ulogd/>
+	  <http://www.gnumonks.org/>
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-- 
1.7.2.1

