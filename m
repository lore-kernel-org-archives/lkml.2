Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab1EBVep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:34:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39453 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1EBVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:34:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=rIRFgoizr4lrCyw1RpdW7OdOMxceIzXNO0W13JeDRPj8dj31nUY6VKNjfpgCTRzSOq
         m30jwl+AjbiHer8RBbDfs7+fTyGfmrR2dTp/rAJkB1hcNlFm12fZvVwL1qW/funwM8SU
         ydJyedwySBzwE/3m4zhJJd2Ar8yrubTcVQtsI=
From: "Kaywinnit L. Frye" <kaywinnit.lee.frye.2497@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Kaywinnit L. Frye" <kaywinnit.lee.frye.2497@gmail.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Subject: [PATCH] wait: include linux/sched.h
Date: Mon,  2 May 2011 22:34:02 +0100
Message-Id: <1304372042-12098-1-git-send-email-kaywinnit.lee.frye.2497@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

signal_pending(), schedule*() and TASK_* are used in various macros in
wait.h and all defined in linux/sched.h

Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Kaywinnit L. Frye <kaywinnit.lee.frye.2497@gmail.com>
---
 include/linux/wait.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 3efc9f3..667a3d7 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -22,6 +22,7 @@
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
+#include <linux/sched.h>
 #include <asm/system.h>
 #include <asm/current.h>
 
-- 
1.7.2.5

