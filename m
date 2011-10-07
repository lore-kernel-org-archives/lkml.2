Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab1JGU2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:28:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58941 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab1JGU2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:28:30 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] MAINTAINERS: Update tegra maintainer information
Date: Fri,  7 Oct 2011 13:27:48 -0700
Message-Id: <1318019268-6946-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of changes to the Tegra maintainership setup:

I'm very glad to bring on Stephen Warren on board as a maintainer. The
work he has done so far is excellent, and the fact that he works for
Nvidia means he has long-term interest in the platform.

Erik Gilling did an astounding amount of work on getting things up and
running but has been a silent partner on the maintainership side for a
while, and is stepping down. Thanks for your contributions so far, Erik.

Finally, update the git URL since I'll take over running the main repo
for a while.

Overall maintainership model isn't changing much at this time: We'll all
three review patches as appropriate, and one of us will collect the main
repo (me at this time).

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Colin Cross <ccross@android.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Stephen Warren <swarren@nvidia.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ace8f9c..5483e0c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6366,10 +6366,10 @@ F:	net/ipv4/tcp_lp.c
 
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
-M:	Erik Gilling <konkers@android.com>
 M:	Olof Johansson <olof@lixom.net>
+M:	Stephen Warren <swarren@nvidia.com>
 L:	linux-tegra@vger.kernel.org
-T:	git git://android.git.kernel.org/kernel/tegra.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/olof/tegra.git
 S:	Supported
 F:	arch/arm/mach-tegra
 
-- 
1.7.4.1

