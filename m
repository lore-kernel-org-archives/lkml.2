Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1CHTDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:03:46 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34697 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab1CHTD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:03:26 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, Michal Hocko <mhocko@suse.cz>
Subject: [PATCH 2/3] AppArmor: cleanup generated files correctly
Date: Tue,  8 Mar 2011 11:03:08 -0800
Message-Id: <1299610989-3917-3-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299610989-3917-1-git-send-email-john.johansen@canonical.com>
References: <1299610989-3917-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean-files should be defined as a variable not a target.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
index 81e5b16..2dafe50 100644
--- a/security/apparmor/Makefile
+++ b/security/apparmor/Makefile
@@ -6,7 +6,7 @@ apparmor-y := apparmorfs.o audit.o capability.o context.o ipc.o lib.o match.o \
               path.o domain.o policy.o policy_unpack.o procattr.o lsm.o \
               resource.o sid.o file.o
 
-clean-files: capability_names.h rlim_names.h
+clean-files := capability_names.h rlim_names.h
 
 
 # Build a lower case string table of capability names
-- 
1.7.1

