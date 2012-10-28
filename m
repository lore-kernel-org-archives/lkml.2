Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2J1Dac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 23:30:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60324 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2J1Dab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 23:30:31 -0400
Date: Sun, 28 Oct 2012 11:30:20 +0800
From: Tekkaman Ninja <tekkamanninja@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>
Subject: [PATCH]Documentation: Fixes a word in Documentation/arm64/memory.txt
Message-ID: <20121028033020.GB3834@Super-MAGI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a term in Documentation/arm64/memory.txt
The modification is based on Catalin Marinas <catalin.marinas@arm.com>'s
suggestion:
    "memory" in "ffffffc000000000 ffffffffffffffff 256GB memory"
    should  be treated as "kernel logical memory map".

Signed-off-by: Fu Wei <tekkamanninja@gmail.com>

---
 Documentation/arm64/memory.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index dbbdcbb..2761652 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -41,7 +41,7 @@ ffffffbe00000000	ffffffbffbffffff	  ~8GB		[guard, future vmmemap]
 
 ffffffbffc000000	ffffffbfffffffff	  64MB		modules
 
-ffffffc000000000	ffffffffffffffff	 256GB		memory
+ffffffc000000000	ffffffffffffffff	 256GB		kernel logical memory map
 
 
 Translation table lookup with 4KB pages:
-- 
1.7.9.5

