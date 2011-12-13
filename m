Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1LMKjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:39:22 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52113 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1LMKjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:39:19 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 01/17] UAPI: Fix arch/mips/include/asm/Kbuild to have separate header-y lines
Date: Tue, 13 Dec 2011 10:03:57 +0000
Message-Id: <1323770653-19177-2-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix arch/mips/include/asm/Kbuild to have a separate header-y line for each
header to make them easier to relocate individually as part of the UAPI header
split.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/Kbuild |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 7897f05..f53f9ca 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -1,3 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
-header-y += cachectl.h sgidefs.h sysmips.h
+header-y += cachectl.h
+header-y += sgidefs.h
+header-y += sysmips.h
-- 
1.7.7.4

