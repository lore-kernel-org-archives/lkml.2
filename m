Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0C1MiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 08:38:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:8853 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab0C1MiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 08:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=TCV6k/bLm5paXLV/YqxgVyGt9XR7GnU6+MpxqupeI1Urj7SVvC5GnlbmQlilqBuhDx
         q+J45/2WT1s5IH7xMEGBDHuEOvm4fHWmt83vKpFQHeIx8JwHp8gNX9yx2kfi5S1tg+M9
         vxQnUDnU5EyG+TM31pRXEBvlS/9vDftiZvV6Y=
Message-ID: <4BAF4DAF.70609@gmail.com>
Date: Sun, 28 Mar 2010 14:38:07 +0200
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] add random binaries to .gitignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds random binaries to .gitignore

-- 
Jan III Sobieski

Signed-off-by: Jan III Sobieski <jan3sobi3ski@gmail.com>

diff --git a/.gitignore b/.gitignore
index a2939fc..b9b624b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -76,3 +76,14 @@ GTAGS
 *.orig
 *~
 \#*#
+
+# random binary files
+Documentation/filesystems/dnotify_test
+Documentation/laptops/dslm
+Documentation/timers/hpet_example
+Documentation/vm/hugepage-mmap
+Documentation/vm/hugepage-shm
+Documentation/vm/map_hugetlb
+arch/x86/boot/compressed/vmlinux
+arch/x86/tools/test_get_len
+
