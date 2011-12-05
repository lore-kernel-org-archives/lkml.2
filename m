Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab1LEWIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:08:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65038 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480Ab1LEWIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:08:47 -0500
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] amd_iommu: Fix typo in kernel-parameters.txt
Date: Mon,  5 Dec 2011 23:08:32 +0100
Message-Id: <1323122912-14532-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.8.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 Documentation/kernel-parameters.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..da50377 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -320,7 +320,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			on: enable for both 32- and 64-bit processes
 			off: disable for both 32- and 64-bit processes
 
-	amd_iommu=	[HW,X86-84]
+	amd_iommu=	[HW,X86-64]
 			Pass parameters to the AMD IOMMU driver in the system.
 			Possible values are:
 			fullflush - enable flushing of IO/TLB entries when
-- 
1.7.8.rc4

