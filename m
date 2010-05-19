Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab0ESKh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:37:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46889 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab0ESKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=smb9FT7+HoQhcUxWEN+aBeEwffyTK0KP+Npdb1Yca4nuohdCeb7kq+SIcfYNbOWEDy
         S/DWevphDEv2foR3nkonj+Bgeh0mCb0YolJ4JZMbeEK0y0PhWRxxSh1HpHXID/fGun/d
         DlYJaQPKtHnsjDnIqovN1NsTs7q1d4jyGFn38=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 2/2] lockup_detector: Don't enable the lockup detector by default
Date: Wed, 19 May 2010 12:37:35 +0200
Message-Id: <1274265455-1948-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274265455-1948-1-git-send-regression-fweisbec@gmail.com>
References: <1274265455-1948-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lockup detector is a new feature that now involves the
nmi watchdog. Drop the default y and let the user choose.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
---
 lib/Kconfig.debug |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e65e47d..63968a9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -155,7 +155,6 @@ config DEBUG_SHIRQ
 config LOCKUP_DETECTOR
 	bool "Detect Hard and Soft Lockups"
 	depends on DEBUG_KERNEL && !S390
-	default y
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
 	  hard and soft lockups.
-- 
1.6.2.3

