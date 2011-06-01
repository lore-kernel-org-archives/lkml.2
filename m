Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029Ab1FADM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:12:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36757 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab1FADKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VltJMOXKQZHsPfeFMGb/UgGI8jsLabAIKoxugxzYkI0rMG1jhlayZNyhs3LmABeSyF
         FTdKcOEJh32+PcZuzj/z1fSB8kTx1qzYpzccE56kk5Q/hSvHxP3/EY/WuUMxxKUYB8pw
         aSs2QEAlJppKBkBJQ0Q0VXrfJ+m2M5lJeqF8Q=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        Will Drewry <wad@chromium.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 07/13] arm: select HAVE_SECCOMP_FILTER
Date: Tue, 31 May 2011 22:10:39 -0500
Message-Id: <1306897845-9393-7-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
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

