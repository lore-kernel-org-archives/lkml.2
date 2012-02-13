Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2BMRoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:44:39 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38108 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755604Ab2BMRoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:44:38 -0500
Message-ID: <1329155075.534.3.camel@joe2Laptop>
Subject: [PATCH] MAINTAINERS: Update MCA section
From: Joe Perches <joe@perches.com>
To: "Pearson, Greg" <greg.pearson@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 13 Feb 2012 09:44:35 -0800
In-Reply-To: <4F39409F.8030603@hp.com>
References: <1329016639.21613.37.camel@dabdike.int.hansenpartnership.com>
	 <4F39409F.8030603@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCA section included a file referring to Machine Check
rather than Microchannel.

Rename the section to spell out Microchannel and drop
the bad file reference.

Noticed-by: Greg Pearson <greg.pearson@hp.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 16cb4d8..98bd9e9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4363,6 +4363,13 @@ T:	git git://git.monstr.eu/linux-2.6-microblaze.git
 S:	Supported
 F:	arch/microblaze/
 
+MICROCHANNEL ARCHITECTURE (MCA)
+M:	James Bottomley <James.Bottomley@HansenPartnership.com>
+S:	Maintained
+F:	Documentation/mca.txt
+F:	drivers/mca/
+F:	include/linux/mca*
+
 MICROTEK X6 SCANNER
 M:	Oliver Neukum <oliver@neukum.name>
 S:	Maintained
@@ -4384,14 +4391,6 @@ M:	Thomas Langer <thomas.langer@lantiq.com>
 S:	Maintained
 F:	arch/mips/lantiq/*
 
-MISCELLANEOUS MCA-SUPPORT
-M:	James Bottomley <James.Bottomley@HansenPartnership.com>
-S:	Maintained
-F:	Documentation/ia64/mca.txt
-F:	Documentation/mca.txt
-F:	drivers/mca/
-F:	include/linux/mca*
-
 MODULE SUPPORT
 M:	Rusty Russell <rusty@rustcorp.com.au>
 S:	Maintained


