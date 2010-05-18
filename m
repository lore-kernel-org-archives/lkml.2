Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab0ERB1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 21:27:16 -0400
Received: from smtp-out.google.com ([74.125.121.35]:13109 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab0ERB1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 21:27:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=uQVF2GgO7QXbAve+J9uo6L6MMPLVg5h9qvCacMkNzm7NmhQ7OVoVPgmjvonhW5RLQ
	eHyxDvFnInlcfG6strIQQ==
From: Michel Lespinasse <walken@google.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] .gitignore arch/x86/boot/compressed/vmlinux
Date: Mon, 17 May 2010 18:23:43 -0700
Message-Id: <1274145823-24137-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/x86/boot/compressed/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/compressed/.gitignore b/arch/x86/boot/compressed/.gitignore
index 4a46fab..b71c8ca 100644
--- a/arch/x86/boot/compressed/.gitignore
+++ b/arch/x86/boot/compressed/.gitignore
@@ -1,4 +1,5 @@
 relocs
+vmlinux
 vmlinux.bin.all
 vmlinux.relocs
 vmlinux.lds
-- 
1.7.0.1

