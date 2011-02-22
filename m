Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1BVJsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:48:17 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:54816 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab1BVJsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:48:16 -0500
From: Romain Francoise <romain@orebokech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] .gitignore: ignore *.xz files
Organization: orebokech dot com
Date: Tue, 22 Feb 2011 10:48:06 +0100
Message-ID: <87oc648ko9.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building with CONFIG_KERNEL_XZ results in the following:

 # Untracked files:
 #   (use "git add <file>..." to include in what will be committed)
 #
 #       arch/x86/boot/compressed/vmlinux.bin.xz

So ignore xz-compressed files at the top level like we already do for
other compression types.

Signed-off-by: Romain Francoise <romain@orebokech.com>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 8faa6c0..5d56a3f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,6 +28,7 @@ modules.builtin
 *.gz
 *.bz2
 *.lzma
+*.xz
 *.lzo
 *.patch
 *.gcno
-- 
1.7.4.1

