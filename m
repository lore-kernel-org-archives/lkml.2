Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0DYLTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 07:19:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44347 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0DYLS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 07:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=dsuXng2UdBjtLNpTtsbb5cRutC5pJlGZwNj2DhaltY+ASmulnVmgvuRuJQ7OhZoLGe
         1CESZKc1/uEQq2VQKVNGoUehUULBzXPES9+pme00qFyPBIRq5theC5eRF9euWHqsjZM2
         WFnTSL6ZfAVUVNLqN1TGiJMGWQChb2tZL1yRQ=
From: Alessio Igor Bogani <abogani@texware.it>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] ptrace: Cleanup useless header
Date: Sun, 25 Apr 2010 13:18:48 +0200
Message-Id: <1272194328-7346-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL isn't anymore present into this file thus it is no necessary still include smp_lock.h.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 kernel/ptrace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1d4883c..6af9cdd 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -14,7 +14,6 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/ptrace.h>
 #include <linux/security.h>
 #include <linux/signal.h>
-- 
1.6.3.3

