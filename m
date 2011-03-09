Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab1CIVrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:47:15 -0500
Received: from mx2.parallels.com ([64.131.90.16]:58700 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1CIVrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:47:12 -0500
Message-ID: <4D77F557.3050002@parallels.com>
Date: Wed, 9 Mar 2011 15:47:03 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove more obsolete Documentation entries.
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.169.44.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rlandley@parallels.com>

Time interpolators were removed in git 1f564ad6d41828
Voyager support went away in git b6b6e2b112caf

Signed-off-by: Rob Landley <rlandley@parallels.com>
---

 Documentation/00-INDEX |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 8dfc670..f607367 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -328,8 +328,6 @@ sysrq.txt
 	- info on the magic SysRq key.
 telephony/
 	- directory with info on telephony (e.g. voice over IP) support.
-time_interpolators.txt
-	- info on time interpolators.
 uml/
 	- directory with information about User Mode Linux.
 unicode.txt
@@ -346,8 +344,6 @@ vm/
 	- directory with info on the Linux vm code.
 volatile-considered-harmful.txt
 	- Why the "volatile" type class should not be used
-voyager.txt
-	- guide to running Linux on the Voyager architecture.
 w1/
 	- directory with documents regarding the 1-wire (w1) subsystem.
 watchdog/
