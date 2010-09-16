Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0IPGCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:02:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:50031 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab0IPGCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:02:13 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] Document the new Anonymous field in smaps.
Date: Thu, 16 Sep 2010 11:34:59 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Matt Mackall <mpm@selenic.com>,
        Richard Guenther <rguenther@suse.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, linux-kernel@vger.kernel.org
References: <AANLkTini3k1hK-9RM6io0mOf4VoDzGpbUEpiv=WHfhEW@mail.gmail.com> <201009160856.25923.knikanth@suse.de> <20100916125147.CA08.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100916125147.CA08.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009161135.00129.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I missed to add documentation, when I sent the patch. This depends on
the patch titled, "[PATCH] Export amount of anonymous memory in a mapping via
smaps".

Thanks
Nikanth


Document the new Anonymous field in smaps.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a6aca87..75c7368 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -370,6 +370,7 @@ Shared_Dirty:          0 kB
 Private_Clean:         0 kB
 Private_Dirty:         0 kB
 Referenced:          892 kB
+Anonymous:             0 kB
 Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
@@ -380,7 +381,10 @@ the amount of the mapping that is currently resident in RAM, the "proportional
 set size” (divide each shared page by the number of processes sharing it), the
 number of clean and dirty shared pages in the mapping, and the number of clean
 and dirty private pages in the mapping.  The "Referenced" indicates the amount
-of memory currently marked as referenced or accessed.
+of memory currently marked as referenced or accessed. The "Anonymous" shows
+the amount of mapping that is not associated with a file. Even the private
+pages in a mapping associated with a file, would become anonymous, when they
+are modified.
 
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
