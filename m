Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2KZKgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:36:00 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35092 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754756Ab2KZKf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:35:58 -0500
Message-ID: <1353926154.2025.40.camel@slavad-ubuntu>
Subject: [PATCH v3 1/5] hfsplus: add osx.* prefix for handling namespace of
 Mac OS X extended attributes
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>, linux-kernel@vger.kernel.org
Date: Mon, 26 Nov 2012 14:35:54 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.177.49.123 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds osx.* prefix for handling namespace of Mac OS X extended attributes.

With the best regards,
Vyacheslav Dubeyko.
---
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v3 1/5] hfsplus: add osx.* prefix for handling namespace of Mac OS X extended attributes

This patch adds osx.* prefix for handling namespace of Mac OS X extended attributes.

Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
---
 include/uapi/linux/xattr.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
index 26607bd..e510d28 100644
--- a/include/uapi/linux/xattr.h
+++ b/include/uapi/linux/xattr.h
@@ -17,6 +17,9 @@
 #define XATTR_OS2_PREFIX "os2."
 #define XATTR_OS2_PREFIX_LEN (sizeof (XATTR_OS2_PREFIX) - 1)
 
+#define XATTR_MAC_OSX_PREFIX "osx."
+#define XATTR_MAC_OSX_PREFIX_LEN (sizeof (XATTR_MAC_OSX_PREFIX) - 1)
+
 #define XATTR_SECURITY_PREFIX	"security."
 #define XATTR_SECURITY_PREFIX_LEN (sizeof (XATTR_SECURITY_PREFIX) - 1)
 
-- 
1.7.9.5



