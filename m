Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964Ab1D2Vli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:41:38 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:35875 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933916Ab1D2VlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:41:18 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB3052.8000503@verizon.net>
Date: Fri, 29 Apr 2011 17:40:34 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH RESEND 3/4] kbuild: make includecheck work in KBUILD_OUTDIR
Content-Type: multipart/mixed;
	boundary="------------040909080100030501050200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------040909080100030501050200
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch fixes the includecheck target so it works when make is
invoked in KBUILD_OUTDIR.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 093c9d2..bfa0e90 100644
--- a/Makefile
+++ b/Makefile
@@ -1396,7 +1396,7 @@ tags TAGS cscope gtags: FORCE
 PHONY += includecheck versioncheck coccicheck namespacecheck export_report

 includecheck:
-	find * $(RCS_FIND_IGNORE) \
+	find $(srctree)/* $(RCS_FIND_IGNORE) \
 		-name '*.[hcS]' -type f -print | sort \
 		| xargs $(PERL) -w $(srctree)/scripts/checkincludes.pl

-- 
1.7.5.rc1



--------------040909080100030501050200
Content-Type: text/plain;
	name="kbuild-make-includecheck-work-in-KBUILD_OUTDIR.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-make-includecheck-work-in-KBUILD_OUTDIR.patch"

>From dac505664370c0821293f62c03d9878a19da1f44 Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 17:18:29 -0400
Subject: [PATCH 05/23] kbuild: make includecheck work in KBUILD_OUTDIR


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 093c9d2..bfa0e90 100644
--- a/Makefile
+++ b/Makefile
@@ -1396,7 +1396,7 @@ tags TAGS cscope gtags: FORCE
 PHONY += includecheck versioncheck coccicheck namespacecheck export_report
 
 includecheck:
-	find * $(RCS_FIND_IGNORE) \
+	find $(srctree)/* $(RCS_FIND_IGNORE) \
 		-name '*.[hcS]' -type f -print | sort \
 		| xargs $(PERL) -w $(srctree)/scripts/checkincludes.pl
 
-- 
1.7.5.rc1



--------------040909080100030501050200--
