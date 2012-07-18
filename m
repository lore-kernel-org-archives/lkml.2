Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2GRQte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:49:34 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:35119 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2GRQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:49:27 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lq387pErHR
X-RZG-CLASS-ID: mo00
From: olaf@aepfle.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] update URL of kexec homepage
Date: Wed, 18 Jul 2012 18:49:21 +0200
Message-Id: <1342630161-16552-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

The referenced html file does not exist anymore. Replace the URL with
the current project homepage.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index 506c739..13f1aa0 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -86,7 +86,7 @@ There is also a gitweb interface available at
 http://www.kernel.org/git/?p=utils/kernel/kexec/kexec-tools.git
 
 More information about kexec-tools can be found at
-http://www.kernel.org/pub/linux/utils/kernel/kexec/README.html
+http://horms.net/projects/kexec/
 
 3) Unpack the tarball with the tar command, as follows:
 
-- 
1.7.10.4

