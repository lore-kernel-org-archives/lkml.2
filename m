Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab1D2WjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:39:17 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:51371 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934024Ab1D2WjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:39:12 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB3DE4.8080207@verizon.net>
Date: Fri, 29 Apr 2011 18:38:28 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH V2 4/7] kbuild: update scripts/.gitignore in preperation for
 moving docproc
Content-Type: multipart/mixed;
	boundary="------------080409070404070809020903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------080409070404070809020903
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch updates scripts/.gitignore in preperation for moving docproc.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/.gitignore b/scripts/.gitignore
index e2741d2..105b21f 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -8,3 +8,4 @@ bin2c
 unifdef
 ihex2fw
 recordmcount
+docproc
-- 
1.7.5.rc1



--------------080409070404070809020903
Content-Type: text/plain;
	name="kbuild-update-scripts-.gitignore-in-preperation-for-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-update-scripts-.gitignore-in-preperation-for-.patch"

>From a4e4700107451f9d207be0edc5e768e24a8027ad Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 19:20:12 -0400
Subject: [PATCH 4/7] kbuild: update scripts/.gitignore in preperation for moving docproc


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/.gitignore b/scripts/.gitignore
index e2741d2..105b21f 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -8,3 +8,4 @@ bin2c
 unifdef
 ihex2fw
 recordmcount
+docproc
-- 
1.7.5.rc1



--------------080409070404070809020903--
