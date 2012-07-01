Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2GANmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:42:53 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:3371 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932456Ab2GANmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:42:52 -0400
Message-ID: <1341150170.1911.116.camel@x61.thuisdomein>
Subject: [PATCH 2/6] [TRIVIAL] x86: remove offsets.h from .gitignore and
 dontdiff
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 01 Jul 2012 15:42:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Jul 2012 13:42:51.0135 (UTC) FILETIME=[68A758F0:01CD578F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 77d1a4999502c260df0eb2de437d320bf8c64b36 ("x86, boot: make
symbols from the main vmlinux available") removed all traces of
offsets.h from the tree. Remove its entries in dontdiff and x86/boot's
.gitignore file too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with git grep only.

1) There's also drivers/staging/media/solo6x10/offsets.h. It has nothing
to do with this stuff. I guess the dontdiff entry would incorrectly
trigger for that file too.

 Documentation/dontdiff   |    1 -
 arch/x86/boot/.gitignore |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index b4a898f..c48e21d 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -183,7 +183,6 @@ modversions.h*
 nconf
 ncscope.*
 offset.h
-offsets.h
 oui.c*
 page-types
 parse.c
diff --git a/arch/x86/boot/.gitignore b/arch/x86/boot/.gitignore
index 851fe93..e3cf9f6 100644
--- a/arch/x86/boot/.gitignore
+++ b/arch/x86/boot/.gitignore
@@ -2,7 +2,6 @@ bootsect
 bzImage
 cpustr.h
 mkcpustr
-offsets.h
 voffset.h
 zoffset.h
 setup
-- 
1.7.7.6

