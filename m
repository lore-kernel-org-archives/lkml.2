Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1G1PzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:55:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab1G1Py5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:54:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 31/40] UAPI: Fix arch/mips/include/asm/Kbuild to have separate
 header-y lines [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>
Date: Thu, 28 Jul 2011 16:54:15 +0100
Message-ID: <20110728155415.16618.69785.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix arch/mips/include/asm/Kbuild to have a separate header-y line for each
header to make them easier to delete individually.

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

