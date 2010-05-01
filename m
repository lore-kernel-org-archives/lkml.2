Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab0EAOnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:43:35 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:64384 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab0EAOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:38:33 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>
Subject: [PATCH v21 100/100] c/r: add an entry for checkpoint/restart in MAINTAINERS
Date: Sat,  1 May 2010 10:16:22 -0400
Message-Id: <1272723382-19470-101-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 MAINTAINERS |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a0e3c3a..e4494d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1501,6 +1501,18 @@ M:	Andy Whitcroft <apw@canonical.com>
 S:	Supported
 F:	scripts/checkpatch.pl
 
+CHECKPOINT-RESTART
+M:	Oren Laadan <orenl@cs.columbia.edu>
+M:	Serge E. Hallyn <serue@us.ibm.com>
+L:	containers@lists.linux-foundation.org
+W:	http://ckpt.wiki.kernel.org/index.php/Main_Page
+S:	Maintained
+F:	*checkpoint*
+K:	checkpoint
+K:	restore
+K:	ckpt
+K:	c/r
+
 CISCO 10G ETHERNET DRIVER
 M:	Scott Feldman <scofeldm@cisco.com>
 M:	Joe Eykholt <jeykholt@cisco.com>
-- 
1.6.3.3

