Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0IKDMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 23:12:34 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42832 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0IKDMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 23:12:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xyW2Zfg4kpIglvac8ZtxVnY3xvjgMB5nGiPuQ9otZ2e+ovw1d+1TPT3a5uTjQ3Xusd
         QNSy9y5Njk3DepSGfg17CErkIg+iZtGkWonlRLREX3pP5ySgoGwG4Oba3kSSX9ejBgvC
         4+7n6E/4b8+fZXSIgJWzt8+dxTKCn2ReQ6RBU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 02/11]fs/ncpfs/Kconfig Update broken web addresses.
Date: Fri, 10 Sep 2010 20:12:43 -0700
Message-Id: <1284174771-7033-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
References: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/ncpfs/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ncpfs/Kconfig b/fs/ncpfs/Kconfig
index c931cf2..4956638 100644
--- a/fs/ncpfs/Kconfig
+++ b/fs/ncpfs/Kconfig
@@ -17,7 +17,8 @@ config NCP_FS
 	  file *server* for Novell NetWare clients.
 
 	  General information about how to connect Linux, Windows machines and
-	  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.
+	  Macs is on the WWW at 
+	  <http://web.archive.org/web/20011204193118/http://www.eats.com/linux_mac_win.html>.
 
 	  To compile this as a module, choose M here: the module will be called
 	  ncpfs.  Say N unless you are connected to a Novell network.
-- 
1.7.2.1

