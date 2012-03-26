Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2CZUNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:13:34 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56857 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab2CZUNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:13:31 -0400
Date: Mon, 26 Mar 2012 13:13:26 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] crc32: Add help text for the algorithm select option
Message-ID: <20120326201326.GB14821@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032620-9360-0000-0000-000004E06A7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add help text to the crc32 algorithm selection option in Kconfig.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 lib/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index 43359bb..403dc13 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -84,6 +84,10 @@ choice
 	prompt "CRC32 implementation"
 	depends on CRC32
 	default CRC32_SLICEBY8
+	help
+	  This option allows a kernel builder to override the default choice
+	  of CRC32 algorithm.  Choose the default ("slice by 8") unless you
+	  know that you need one of the others.
 
 config CRC32_SLICEBY8
 	bool "Slice by 8 bytes"

