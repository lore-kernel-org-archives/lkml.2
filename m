Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0KYBa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 20:30:28 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:46455 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0KYBa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 20:30:27 -0500
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: Pavel Machek <pma@sysgo.com>, Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.or>,
        Jiri Kosina <trivial@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH] kdump: update kexec-tools URL and Vivek's email
Date: Thu, 25 Nov 2010 10:30:12 +0900
Message-Id: <1290648612-14964-1-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Simon Horman <horms@verge.net.au>
---
 Documentation/kdump/kdump.txt |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index cab61d8..7a9e0b4 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -65,18 +65,21 @@ Install kexec-tools
 
 2) Download the kexec-tools user-space package from the following URL:
 
-http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools.tar.gz
+http://kernel.org/pub/linux/utils/kernel/kexec/kexec-tools.tar.gz
 
 This is a symlink to the latest version.
 
 The latest kexec-tools git tree is available at:
 
-git://git.kernel.org/pub/scm/linux/kernel/git/horms/kexec-tools.git
-or
-http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools.git
+git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git
+and
+http://www.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git
+
+There is also a gitweb interface available at
+http://www.kernel.org/git/?p=utils/kernel/kexec/kexec-tools.git
 
 More information about kexec-tools can be found at
-http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/README.html
+http://www.kernel.org/pub/linux/utils/kernel/kexec/README.html
 
 3) Unpack the tarball with the tar command, as follows:
 
@@ -439,6 +442,6 @@ To Do
 Contact
 =======
 
-Vivek Goyal (vgoyal@in.ibm.com)
+Vivek Goyal (vgoyal@redhat.com)
 Maneesh Soni (maneesh@in.ibm.com)
 
-- 
1.7.2.3

