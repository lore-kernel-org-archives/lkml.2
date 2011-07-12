Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1GLUYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab1GLUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:24:39 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] MAINTAINERS: Add a maintainer for EFI
Date: Tue, 12 Jul 2011 16:24:03 -0400
Message-Id: <1310502243-19306-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1310502243-19306-1-git-send-email-mjg@redhat.com>
References: <1310502243-19306-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since people other than ia64 are actually trying to use this now, it
should probably be maintained. Sigh.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 187282d..731e345 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2421,6 +2421,12 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
 S:	Maintained
 F:	sound/usb/misc/ua101.c
 
+EFI
+M:	Matthew Garrett <mjg@redhat.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/firmware/efi/
+
 EFIFB FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 M:	Peter Jones <pjones@redhat.com>
-- 
1.7.6

