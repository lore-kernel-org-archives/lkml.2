Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0LIEHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 23:07:55 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42023 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0LIEHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 23:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YfyPngZcL0LTBM1uTrhDGWhaIMqwW6MuGzMP5mWG8cAfvyyITRjgY5d6NSd/uB0Ie+
         X9W2m0+0nsyWyqcrgFk4959COUFubONBaCVGlhXA/r90yJqqK/+V7k7iLqLCm92EmZFw
         uv+ric6d5zsCEJGaAvCoyfFQaXiOKcz4WaAVU=
From: Namhyung Kim <namhyung@gmail.com>
To: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] alpha/osf_sys: remove unused MAX_SELECT_SECONDS
Date: Thu,  9 Dec 2010 13:07:21 +0900
Message-Id: <1291867641-31998-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the leftover from the commit 14e2acd86865 ("select:
fix alpha OSF wrapper").

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/alpha/kernel/osf_sys.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 547e8b84b2f7..fe698b5045e9 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -951,9 +951,6 @@ SYSCALL_DEFINE2(osf_utimes, const char __user *, filename,
 	return do_utimes(AT_FDCWD, filename, tvs ? tv : NULL, 0);
 }
 
-#define MAX_SELECT_SECONDS \
-	((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
-
 SYSCALL_DEFINE5(osf_select, int, n, fd_set __user *, inp, fd_set __user *, outp,
 		fd_set __user *, exp, struct timeval32 __user *, tvp)
 {
-- 
1.7.3.3.400.g93cef

