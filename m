Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab2JXIHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:07:31 -0400
Received: from ra.se.axis.com ([195.60.68.13]:49725 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897Ab2JXIHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:07:24 -0400
Date: Wed, 24 Oct 2012 10:07:22 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: David Howells <dhowells@redhat.com>
Cc: starvik@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UAPI: Fix up empty files in arch/cris/
Message-ID: <20121024080721.GB29793@axis.com>
References: <20121022121844.14852.49121.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022121844.14852.49121.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 01:18:44PM +0100, David Howells wrote:
> Fix up three empty files in arch/cris/ by sticking placeholder comments in
> there to prevent the patch program from deleting them.
> 
> I decided not to delete the arch-v*/Kbuild files as it's possibly someone might
> want to use them for genhdr-y lines in the future, but they could be deleted
> and the pointer lines removed from asm/Kbuild.  The uapi/arch-v*/Kbuild files
> ought to be uneffected by such a change.
> 
> asm/swab.h didn't have anything outside of __KERNEL__ so nothing appeared in
> uapi/asm/swab.h.  The latter, however, is exported by Kbuild.asm.
> 
> This needs to be applied after the CRIS UAPI disintegration patch.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Thanks, I've rewritten the comments to match the canonical name of the
architectures, and applied the following patch to the CRIS-tree
(with the same comment as above).

---
 arch/cris/include/arch-v10/arch/Kbuild | 1 +
 arch/cris/include/arch-v32/arch/Kbuild | 1 +
 arch/cris/include/uapi/asm/swab.h      | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/arch/cris/include/arch-v10/arch/Kbuild b/arch/cris/include/arch-v10/arch/Kbuild
index e69de29..1f0fc7a 100644
--- a/arch/cris/include/arch-v10/arch/Kbuild
+++ b/arch/cris/include/arch-v10/arch/Kbuild
@@ -0,0 +1 @@
+# CRISv10 arch
diff --git a/arch/cris/include/arch-v32/arch/Kbuild b/arch/cris/include/arch-v32/arch/Kbuild
index e69de29..2fd65c7 100644
--- a/arch/cris/include/arch-v32/arch/Kbuild
+++ b/arch/cris/include/arch-v32/arch/Kbuild
@@ -0,0 +1 @@
+# CRISv32 arch
diff --git a/arch/cris/include/uapi/asm/swab.h b/arch/cris/include/uapi/asm/swab.h
index e69de29..4adf1e9 100644
--- a/arch/cris/include/uapi/asm/swab.h
+++ b/arch/cris/include/uapi/asm/swab.h
@@ -0,0 +1,3 @@
+/*
+ * CRIS byte swapping.
+ */


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
