Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab1CHTDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:03:34 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34736 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab1CHTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:03:31 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, Shan Wei <shanwei@cn.fujitsu.com>
Subject: [PATCH 3/3] AppArmor: kill unused macros in lsm.c
Date: Tue,  8 Mar 2011 11:03:09 -0800
Message-Id: <1299610989-3917-4-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299610989-3917-1-git-send-email-john.johansen@canonical.com>
References: <1299610989-3917-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused macros.
V3: param_check_aabool, param_check_aauint and param_check_aalockpolicy
are used by module_param_named implicitly.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/lsm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index b7106f1..d21a427 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -693,11 +693,9 @@ static struct kernel_param_ops param_ops_aalockpolicy = {
 
 static int param_set_audit(const char *val, struct kernel_param *kp);
 static int param_get_audit(char *buffer, struct kernel_param *kp);
-#define param_check_audit(name, p) __param_check(name, p, int)
 
 static int param_set_mode(const char *val, struct kernel_param *kp);
 static int param_get_mode(char *buffer, struct kernel_param *kp);
-#define param_check_mode(name, p) __param_check(name, p, int)
 
 /* Flag values, also controllable via /sys/module/apparmor/parameters
  * We define special types as we want to do additional mediation.
-- 
1.7.1

