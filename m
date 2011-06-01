Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161061Ab1FADLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:11:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36757 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161048Ab1FADLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iM/CgvBnG213V2y7r2nDPR+HU3bR4PuKiRqBQNKB+/P2SzIQegtPJA5U3lbCimrPc5
         3ouYqVh8krI/UZEGFZZCNK3WRoT5l0NKbDdBT/irvnmbnItn4HRVgwHyv2Xh43vzqNJb
         KhbjH8OfP9bBcSu/U/ErogxFt5ghJptJzlOPo=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        Will Drewry <wad@chromium.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
Subject: [PATCH v3 13/13] sh: select HAVE_SECCOMP_FILTER
Date: Tue, 31 May 2011 22:10:45 -0500
Message-Id: <1306897845-9393-13-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
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

