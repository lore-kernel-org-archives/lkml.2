Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1HMTfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 15:35:32 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33169 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752502Ab1HMTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 15:35:24 -0400
Date: Sat, 13 Aug 2011 12:34:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Marcos Souza <marcos.mage@gmail.com>
Subject: [PATCH 8/8] Documentation: befs.txt: no maintainer, orphaned
Message-Id: <20110813123459.b8f1493e.rdunlap@xenotime.net>
In-Reply-To: <20110813122200.8e2fc879.rdunlap@xenotime.net>
References: <20110813122200.8e2fc879.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcos Souza <marcos.mage@gmail.com>

Remove the name of Sergey Kostyliov as maintainer of befs.
In the MAINTAINERS file, befs is orphaned.

Signed-off-by: Marcos Souza <marcos.mage@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/filesystems/befs.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-31-rc1-git7.orig/Documentation/filesystems/befs.txt
+++ lnx-31-rc1-git7/Documentation/filesystems/befs.txt
@@ -27,7 +27,7 @@ His original code can still be found at:
 Does anyone know of a more current email address for Makoto? He doesn't
 respond to the address given above...
 
-Current maintainer: Sergey S. Kostyliov <rathamahata@php4.ru>
+This filesystem doesn't have a maintainer.
 
 WHAT IS THIS DRIVER?
 ==================
