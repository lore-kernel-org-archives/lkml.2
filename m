Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab2GANlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:41:55 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:2290 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932455Ab2GANlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:41:53 -0400
Message-ID: <1341150112.1911.114.camel@x61.thuisdomein>
Subject: [PATCH 1/6] [TRIVIAL] powerpc: remove four unused files from
 .gitignore
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 01 Jul 2012 15:41:52 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Jul 2012 13:41:52.0587 (UTC) FILETIME=[45C1A1B0:01CD578F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4f3865fb57a04db7cca068fed1c15badc064a302 ("zlib_inflate: Upgrade
library code to a recent version") removed infblock.c, infblock.h,
infcodes.c, and infcodes.h from the tree. Remove their entries in
powerpc's .gitignore file too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with git grep only.

 arch/powerpc/boot/.gitignore |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/boot/.gitignore b/arch/powerpc/boot/.gitignore
index 1c1aadc..c32ae5c 100644
--- a/arch/powerpc/boot/.gitignore
+++ b/arch/powerpc/boot/.gitignore
@@ -1,10 +1,6 @@
 addnote
 empty.c
 hack-coff
-infblock.c
-infblock.h
-infcodes.c
-infcodes.h
 inffast.c
 inffast.h
 inffixed.h
-- 
1.7.7.6

