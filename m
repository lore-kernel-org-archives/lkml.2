Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1FCUc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:32:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42597 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab1FCUcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WX7ucyjI0HvrYp470nDyB44eKrg5l3e8iosf+LAFtZhxP6k0GtEzEC5K7zD1oEwxTv
         RuG/iX6ETsX1ys1J0f+gBXjM0d6gMhWPum4pAPzsOqh0B+pkgHaQXoKvbxx02Gxsgksb
         VaTR+50/G1B0yv9TTV3bXxQJmI64X585SwwiA=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        paulmck@linux.vnet.ibm.com, Will Drewry <wad@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 07/13] arm: select HAVE_SECCOMP_FILTER
Date: Fri,  3 Jun 2011 15:34:06 -0500
Message-Id: <1307133252-23259-7-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1307133252-23259-1-git-send-email-wad@chromium.org>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable support for CONFIG_SECCOMP_FILTER by selecting HAVE_SECCOMP_FILTER by
default.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 377a7a5..4725fbc 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -16,6 +16,7 @@ config ARM
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
 	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
+	select HAVE_SECCOMP_FILTER
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
-- 
1.7.0.4

