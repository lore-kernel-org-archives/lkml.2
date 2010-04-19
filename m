Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0DSOnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:43:43 -0400
Received: from zmc.proxad.net ([212.27.53.206]:38124 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab0DSOnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:43:42 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.975
From: Florian Fainelli <ffainelli@freebox.fr>
Date: Mon, 19 Apr 2010 16:42:52 +0200
Subject: [PATCH] globally ignore Module.symvers
MIME-Version: 1.0
X-Length: 1226
Organization: Freebox
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004191642.52517.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we build using make SUBDIRS=foo/ Kbuild will output per-directory
Module.symvers files that we do not want to keep track of. Ignore these files
globally.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
diff --git a/.gitignore b/.gitignore
index a2939fc..441bf1b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -41,7 +41,7 @@ modules.builtin
 /vmlinuz
 /System.map
 /Module.markers
-/Module.symvers
+Module.symvers
 
 #
 # git files that we don't want to ignore even it they are dot-files


