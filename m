Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab0FSU5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:57:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36193 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0FSU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OBcEr2MjWfRkmGxnFv9uCN2dxdDOzWDDxBBb3jtVH3Kq+uo4SuED3MiXF2OkVp+P/Q
         C2Fxi4k9H1BkcUMwOwOxS3O0WW+fi3VookaV8evOQi/XVw3LwYfTiE3SNu3UEwjVKIiQ
         uCw2UbiWXg9gCp+FwHh9r8Khy/BlWYhpyel8c=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]MAINTAINERS update e-mail address
Date: Sat, 19 Jun 2010 13:56:51 -0700
Message-Id: <1276981011-25092-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_maintainer.pl did it's job.. just the MAINTAINERS
file need to be updated or else you get this:
subject:Auto-response for your message to the "linux-cifs-client" mailing list

The linux-cifs-client@lists.samba.org mailing list is now deprecated.
The new mailing list is linux-cifs@vger.kernel.org. Subscription is no
longer required to post to that list. Please resend your message
there.

so update the linux-cifs address in the MAINTAINERS file.
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d119c9..8d6a3ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1581,7 +1581,7 @@ F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 M:	Steve French <sfrench@samba.org>
-L:	linux-cifs-client@lists.samba.org (moderated for non-subscribers)
+L:	linux-cifs@vger.kernel.org	
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
 Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
-- 
1.7.1.rc1.21.gf3bd6

