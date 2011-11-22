Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab1KVBL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:11:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040Ab1KVBLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:11:25 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/7] MAINTAINERS: add CHAR and MISC driver maintainers
Date: Mon, 21 Nov 2011 17:10:28 -0800
Message-Id: <1321924234-26258-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20111122005836.GA25420@kroah.com>
References: <20111122005836.GA25420@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, we are fools, but humor us.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4808256..c9c0643 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1788,6 +1788,14 @@ F:	include/net/cfg80211.h
 F:	net/wireless/*
 X:	net/wireless/wext*
 
+CHAR and MISC DRIVERS
+M:	Arnd Bergmann <arnd@arndb.de>
+M:	Greg Kroah-Hartman <greg@kroah.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
+S:	Maintained
+F:	drivers/char/*
+F:	drivers/misc/*
+
 CHECKPATCH
 M:	Andy Whitcroft <apw@canonical.com>
 S:	Supported
-- 
1.7.7.3

