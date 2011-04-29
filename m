Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022Ab1D2WjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:39:09 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:51359 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934012Ab1D2WjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:39:06 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB3DDD.2020808@verizon.net>
Date: Fri, 29 Apr 2011 18:38:21 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH V2 1/7] kbuild: update DocBook Makefile in preperation for
 moving docproc
Content-Type: multipart/mixed;
	boundary="------------060706070408040606010200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------060706070408040606010200
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch updates the DocBook Makefile in preperation for moving docproc.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Documentation/DocBook/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 8436b01..3cebfa0 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -73,7 +73,7 @@ installmandocs: mandocs
 ###
 #External programs used
 KERNELDOC = $(srctree)/scripts/kernel-doc
-DOCPROC   = $(objtree)/scripts/basic/docproc
+DOCPROC   = $(objtree)/scripts/docproc

 XMLTOFLAGS = -m $(srctree)/Documentation/DocBook/stylesheet.xsl
 XMLTOFLAGS += --skip-validation
-- 
1.7.5.rc1



--------------060706070408040606010200
Content-Type: text/plain;
	name="kbuild-update-DocBook-Makefile-in-preperation-for-mo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-update-DocBook-Makefile-in-preperation-for-mo.patch"

>From 47d59da1cf32635086e77fb515486d6dd4f32b76 Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 19:12:32 -0400
Subject: [PATCH 1/7] kbuild: update DocBook Makefile in preperation for moving docproc


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Documentation/DocBook/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 8436b01..3cebfa0 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -73,7 +73,7 @@ installmandocs: mandocs
 ###
 #External programs used
 KERNELDOC = $(srctree)/scripts/kernel-doc
-DOCPROC   = $(objtree)/scripts/basic/docproc
+DOCPROC   = $(objtree)/scripts/docproc
 
 XMLTOFLAGS = -m $(srctree)/Documentation/DocBook/stylesheet.xsl
 XMLTOFLAGS += --skip-validation
-- 
1.7.5.rc1



--------------060706070408040606010200--
