Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2GANpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:45:53 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:4171 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932331Ab2GANpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:45:52 -0400
Message-ID: <1341150350.1911.120.camel@x61.thuisdomein>
Subject: [PATCH 5/6] AppArmor: remove af_names.h from .gitignore
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 01 Jul 2012 15:45:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Jul 2012 13:45:50.0823 (UTC) FILETIME=[D3C18F70:01CD578F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4fdef2183e6598cc977a9bb9321ef99a44125da3 ("AppArmor: Cleanup make
file to remove cruft and make it easier to read") removed all traces of
af_names.h from the tree. Remove its entry in AppArmor's .gitignore file
too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with git grep only.

 security/apparmor/.gitignore |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/.gitignore b/security/apparmor/.gitignore
index 4d995ae..9cdec70 100644
--- a/security/apparmor/.gitignore
+++ b/security/apparmor/.gitignore
@@ -1,6 +1,5 @@
 #
 # Generated include files
 #
-af_names.h
 capability_names.h
 rlim_names.h
-- 
1.7.7.6

