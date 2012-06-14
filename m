Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab2FNIGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:06:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab2FNIGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:06:45 -0400
X-IronPort-AV: E=Sophos;i="4.77,408,1336320000"; 
   d="scan'208";a="5186944"
Message-ID: <4FD99C88.2010002@cn.fujitsu.com>
Date: Thu, 14 Jun 2012 16:10:48 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: rob@landley.net, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhelgaas@google.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] doc: update mem= option's spec
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/14 16:07:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/14 16:07:15,
	Serialize complete at 2012/06/14 16:07:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current mem= implementation seems buggy because specification and
implementation doesn't match. Current mem= has been working
for many years and it's not buggy, it works as expected. So
we should update the specification.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a92c5eb..924b1a4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1471,9 +1471,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
 			Amount of memory to be used when the kernel is not able
 			to see the whole system memory or for test.
-			[X86-32] Use together with memmap= to avoid physical
-			address space collisions. Without memmap= PCI devices
-			could be placed at addresses belonging to unused RAM.
+			[X86-32] Work as limiting max address. Use together
+			with memmap= to avoid physical address space collisions.
+			Without memmap= PCI devices could be placed at addresses
+			belonging to unused RAM.
 
 	mem=nopentium	[BUGS=X86-32] Disable usage of 4MB pages for kernel
 			memory.
-- 
1.7.1

