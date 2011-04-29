Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035Ab1D2WkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:40:25 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:51362 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755075Ab1D2WjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:39:08 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB3DE0.5040105@verizon.net>
Date: Fri, 29 Apr 2011 18:38:24 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH V2 3/7] kbuild: update scripts/basic/.gitignore in preperation
 for moving docproc
Content-Type: multipart/mixed;
	boundary="------------000004000908000201050504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000004000908000201050504
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch updates scripts/basic/.gitignore in preperation for moving
docproc.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/basic/.gitignore |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/scripts/basic/.gitignore b/scripts/basic/.gitignore
index bf8b199..a776371 100644
--- a/scripts/basic/.gitignore
+++ b/scripts/basic/.gitignore
@@ -1,3 +1 @@
-hash
 fixdep
-docproc
-- 
1.7.5.rc1



--------------000004000908000201050504
Content-Type: text/plain;
	name="kbuild-update-scripts-basic-.gitignore-in-preperatio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-update-scripts-basic-.gitignore-in-preperatio.patch"

>From 8368e39cf774cdbdec3c095307ed96f4f32bf4f1 Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 19:19:12 -0400
Subject: [PATCH 3/7] kbuild: update scripts/basic/.gitignore in preperation for moving docproc


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/basic/.gitignore |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/scripts/basic/.gitignore b/scripts/basic/.gitignore
index bf8b199..a776371 100644
--- a/scripts/basic/.gitignore
+++ b/scripts/basic/.gitignore
@@ -1,3 +1 @@
-hash
 fixdep
-docproc
-- 
1.7.5.rc1



--------------000004000908000201050504--
