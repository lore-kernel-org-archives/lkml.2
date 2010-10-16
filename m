Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab0JPBRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:17:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab0JPBRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:17:14 -0400
Date: Fri, 15 Oct 2010 21:17:13 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, takata@linux-m32r.org,
        linux-m32r@ml.linux-m32r.org, viro@zeniv.linux.org.uk
Subject: [PATCH 3/4] m32r: add kernel/.gitignore and ignore vmlinux.lds
Message-ID: <20101016011713.GU8332@bombadil.infradead.org>
References: <20101016010952.GQ8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016010952.GQ8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/m32r/kernel/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 arch/m32r/kernel/.gitignore

diff --git a/arch/m32r/kernel/.gitignore b/arch/m32r/kernel/.gitignore
new file mode 100644
index 0000000..c5f676c
--- /dev/null
+++ b/arch/m32r/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
-- 
1.7.3.1

