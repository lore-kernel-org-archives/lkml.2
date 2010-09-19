Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0ITDyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 23:54:11 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:39815 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab0ITDyB (ORCPT
	<rfc822;groupwise-KNikanth@novell.com:0:0>);
	Sun, 19 Sep 2010 23:54:01 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Richard Guenther <rguenther@suse.de>
Subject: [PATCH] Document /proc/pid/pagemap in Documentation/filesystems/proc.txt
Date: Sun, 19 Sep 2010 23:08:20 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
References: <20100915134724.C9EE.A69D9226@jp.fujitsu.com> <alpine.LNX.2.00.1009151612450.28912@zhemvz.fhfr.qr> <201009192307.09309.knikanth@suse.de>
In-Reply-To: <201009192307.09309.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009192308.20500.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document /proc/pid/pagemap in Documentation/filesystems/proc.txt

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---


diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a6aca87..a9c85a6 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -136,6 +136,7 @@ Table 1-1: Process specific entries in /proc
  statm		Process memory status information
  status		Process status in human readable form
  wchan		If CONFIG_KALLSYMS is set, a pre-decoded wchan
+ pagemap	Page table
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		a extension based on maps, showing the memory consumption of
 		each mapping
@@ -397,6 +398,9 @@ To clear the bits for the file mapped pages associated with the process
     > echo 3 > /proc/PID/clear_refs
 Any other value written to /proc/PID/clear_refs will have no effect.
 
+The /proc/pid/pagemap gives the PFN, which can be used to find the pageflags
+using /proc/kpageflags and number of times a page is mapped using
+/proc/kpagecount. For detailed explanation, see Documentation/vm/pagemap.txt.
 
 1.2 Kernel data
 ---------------
