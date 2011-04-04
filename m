Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1DDWMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:12:41 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:51721 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752484Ab1DDWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:12:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=p5ifs32rhWiHoH3suZ+GHEZKpx0CGr3UyaHtiIefUODvOM6AgHCLnRtfeRlIcz8KX2+gZldPAqQBg556sJfbRIwhKcY1XXYq3TDJ1fdNL04vBAyR4TNr4m+JGuGO5515;
Date: Mon, 4 Apr 2011 14:58:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Daniel Baluta <dbaluta@ixiacom.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 1/8] Documentation: update kmemleak arch. info
Message-Id: <20110404145803.8663081d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Baluta <dbaluta@ixiacom.com>

Besides x86 and arm, kmemleak now supports powerpc, sparc, sh,
microblaze and tile.

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kmemleak.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.38-git18.orig/Documentation/kmemleak.txt
+++ linux-2.6.38-git18/Documentation/kmemleak.txt
@@ -11,6 +11,7 @@ with the difference that the orphan obje
 reported via /sys/kernel/debug/kmemleak. A similar method is used by the
 Valgrind tool (memcheck --leak-check) to detect the memory leaks in
 user-space applications.
+Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
 
 Usage
 -----
@@ -178,5 +179,4 @@ block doesn't need to be freed (some cas
 the pointer is calculated by other methods than the usual container_of
 macro or the pointer is stored in a location not scanned by kmemleak.
 
-Page allocations and ioremap are not tracked. Only the ARM and x86
-architectures are currently supported.
+Page allocations and ioremap are not tracked.
