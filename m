Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1AGWqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:46:46 -0500
Received: from usindmx01.hds.com ([207.126.252.12]:54289 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab1AGWqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:46:44 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Fri, 7 Jan 2011 17:04:58 -0500
Subject: [RFC][PATCH 1/2] Add explanation about min_free_kbytes to clarify
 its effect
Thread-Topic: [RFC][PATCH 1/2] Add explanation about min_free_kbytes to
 clarify its effect
Thread-Index: AcuutsHgFEJGwsPbT6epur3gKhhD/gAAAZdw
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A297@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document that changing min_free_kbytes affects not only watermark[min]
but also watermark[low,high].

Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>
---
 Documentation/sysctl/vm.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 30289fa..e10b279 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -349,7 +349,8 @@ min_free_kbytes:
 
 This is used to force the Linux VM to keep a minimum number
 of kilobytes free.  The VM uses this number to compute a
-watermark[WMARK_MIN] value for each lowmem zone in the system.
+watermark[WMARK_MIN] for each lowmem zone and
+watermark[WMARK_LOW/WMARK_HIGH] for each zone in the system.
 Each lowmem zone gets a number of reserved free pages based
 proportionally on its size.
 
-- 
1.7.1

