Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2LCKhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:37:00 -0500
Received: from ra.se.axis.com ([195.60.68.13]:56400 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2LCKg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:36:58 -0500
Date: Mon, 3 Dec 2012 11:36:54 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Fix cifs-tree git url
Message-ID: <20121203103654.GY27196@axis.com>
References: <20121129173053.GQ27196@axis.com>
 <CAH2r5mvKGnZdUNb1-Msb10NBypG2cQm+5JrN-Ajv8VNvmX2+Pg@mail.gmail.com>
 <20121129184709.GR27196@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129184709.GR27196@axis.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cifs-tree is no longer found on kernel.org,
but linux-next uses the tree on samba.org, so use that instead.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 244b2f2..60d0e35 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2009,7 +2009,7 @@ L:	linux-cifs@vger.kernel.org
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
 Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
+T:	git git://git.samba.org/sfrench/cifs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/cifs.txt
 F:	fs/cifs/
-- 
1.7.11.7


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
