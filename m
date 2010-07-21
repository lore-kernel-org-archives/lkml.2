Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab0GUE4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:56:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62631 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762162Ab0GUEzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vr/dsWrnUnVEWzelMqq7cgqiVKXsQMbFVpY5IJNh15q2bHQqpAqwXY5nPoJzEuMXQK
         xzMKbgpe4U2l8+1wOZ91HCHW9a4Idjgpcw/hjqMEmbi40gbVUL6bgS0FLXKtDq9J//pu
         i/TOLF4DHu6qPR4a6uiI0W99SEpWSGWqOJbL4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 79/79]Documentation/networking/udplite.txt update web address.
Date: Tue, 20 Jul 2010 21:55:42 -0700
Message-Id: <1279688153-29571-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
References: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Th epatch below updates a broken web addres, as well as removes
a broken web address due to not knowing where this might be.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/udplite.txt |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/udplite.txt b/Documentation/networking/udplite.txt
index 855d8da..ee55b53 100644
--- a/Documentation/networking/udplite.txt
+++ b/Documentation/networking/udplite.txt
@@ -11,12 +11,9 @@
   This file briefly describes the existing kernel support and the socket API.
   For in-depth information, you can consult:
 
-   o The UDP-Lite Homepage: http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/
+   o The UDP-Lite Homepage: http://en.wikipedia.org/wiki/UDP_Lite 
        From here you can also download some example application source code.
 
-   o The UDP-Lite HOWTO on
-       http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/files/UDP-Lite-HOWTO.txt
-
    o The Wireshark UDP-Lite WiKi (with capture files):
        http://wiki.wireshark.org/Lightweight_User_Datagram_Protocol
 
@@ -28,8 +25,6 @@
   Several applications have been ported successfully to UDP-Lite. Ethereal
   (now called wireshark) has UDP-Litev4/v6 support by default. The tarball on
 
-   http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/files/udplite_linux.tar.gz
-
   has source code for several v4/v6 client-server and network testing examples.
 
   Porting applications to UDP-Lite is straightforward: only socket level and
-- 
1.7.1.rc1.21.gf3bd6

