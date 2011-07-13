Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab1GMT7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 15:59:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab1GMT7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 15:59:41 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, tony.luck@intel.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 2/2] MAINTAINERS: Add a maintainer for EFI
Date: Wed, 13 Jul 2011 15:59:04 -0400
Message-Id: <1310587144-14192-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1310587144-14192-1-git-send-email-mjg@redhat.com>
References: <4E1DEAA2.80208@zytor.com>
 <1310587144-14192-1-git-send-email-mjg@redhat.com>
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
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 187282d..b551c06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2421,6 +2421,11 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
 S:	Maintained
 F:	sound/usb/misc/ua101.c
 
+EFI
+M:	Matthew Garrett <mjg@redhat.com>
+S:	Maintained
+F:	drivers/firmware/efi/
+
 EFIFB FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 M:	Peter Jones <pjones@redhat.com>
-- 
1.7.6

