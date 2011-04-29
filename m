Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010Ab1D2WjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:39:05 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:51342 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756186Ab1D2WjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:39:01 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB3DD9.3080607@verizon.net>
Date: Fri, 29 Apr 2011 18:38:17 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH V2 2/7] kbuild: update scripts/basic/Makefile in preperation
 for moving docproc
Content-Type: multipart/mixed;
	boundary="------------000109050605050806060902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000109050605050806060902
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch updates scripts/basic/Makefile in preperation for moving docproc.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/basic/Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/scripts/basic/Makefile b/scripts/basic/Makefile
index 4c324a1..4fcef87 100644
--- a/scripts/basic/Makefile
+++ b/scripts/basic/Makefile
@@ -7,9 +7,8 @@
 # .config is included by main Makefile.
 #
---------------------------------------------------------------------------
 # fixdep: 	 Used to generate dependency information during build process
-# docproc:	 Used in Documentation/DocBook

-hostprogs-y	:= fixdep docproc
+hostprogs-y	:= fixdep
 always		:= $(hostprogs-y)

 # fixdep is needed to compile other host programs
-- 
1.7.5.rc1



--------------000109050605050806060902
Content-Type: text/plain;
	name="kbuild-update-scripts-basic-Makefile-in-preperation-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-update-scripts-basic-Makefile-in-preperation-.patch"

>From 87935415b9162f2402fe6877ea413a72c5516be4 Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 19:14:24 -0400
Subject: [PATCH 2/7] kbuild: update scripts/basic/Makefile in preperation for moving docproc


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/basic/Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/scripts/basic/Makefile b/scripts/basic/Makefile
index 4c324a1..4fcef87 100644
--- a/scripts/basic/Makefile
+++ b/scripts/basic/Makefile
@@ -7,9 +7,8 @@
 # .config is included by main Makefile.
 # ---------------------------------------------------------------------------
 # fixdep: 	 Used to generate dependency information during build process
-# docproc:	 Used in Documentation/DocBook
 
-hostprogs-y	:= fixdep docproc
+hostprogs-y	:= fixdep
 always		:= $(hostprogs-y)
 
 # fixdep is needed to compile other host programs
-- 
1.7.5.rc1



--------------000109050605050806060902--
