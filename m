Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1FCUco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:32:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47512 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab1FCUcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DxSueGpdZpGOjlmBsbyatqnENucuVIlNJobmGn035ZeRPm83fk0nh28HbI+CU+XQLj
         5rzl2NgWvhSpqUGrnLQYD6r958gdDdOEb7A4BGrM0V8nRWfLnteTu1yx88hzRrzT+1kL
         xVoRxBdf+6i7XN2jmULd85O60hpjcHyYZoiFI=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        paulmck@linux.vnet.ibm.com, Will Drewry <wad@chromium.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH v4 13/13] sh: select HAVE_SECCOMP_FILTER
Date: Fri,  3 Jun 2011 15:34:12 -0500
Message-Id: <1307133252-23259-13-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1307133252-23259-1-git-send-email-wad@chromium.org>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for CONFIG_SECCOMP_FILTER by selecting HAVE_SECCOMP_FILTER.
---
 arch/sh/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 4b89da2..41ea3a7 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -10,6 +10,7 @@ config SUPERH
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
 	select HAVE_IRQ_WORK
+	select HAVE_SECCOMP_FILTER
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_KERNEL_GZIP
-- 
1.7.0.4

