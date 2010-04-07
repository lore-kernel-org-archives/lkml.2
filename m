Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0DGMtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:49:35 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:30894 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718Ab0DGMsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:08 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh2a8h87h65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJT-01-9UQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/12] x86/amd-iommu: Remove obsolete parameter documentation
Date: Wed, 7 Apr 2010 14:46:47 +0200
Message-ID: <1270644409-10123-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:56.0086 (UTC) FILETIME=[67CF7F60:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the share and fullflush parameters was removed.
Remove the documentation about them too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/kernel-parameters.txt |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e7848a0..ccea846 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -323,11 +323,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	amd_iommu=	[HW,X86-84]
 			Pass parameters to the AMD IOMMU driver in the system.
 			Possible values are:
-			isolate - enable device isolation (each device, as far
-			          as possible, will get its own protection
-			          domain) [default]
-			share - put every device behind one IOMMU into the
-				same protection domain
 			fullflush - enable flushing of IO/TLB entries when
 				    they are unmapped. Otherwise they are
 				    flushed before they will be reused, which
-- 
1.7.0.4


