Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1G0EFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:05:45 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55713 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171Ab1G0EFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:05:41 -0400
X-Sasl-enc: RdzG4HigYuyEAdVogJ8pcwcpFPDRt3rAXepfqTcoGXnp 1311739540
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/11] driver core: add more help description for "path to uevent helper"
Date: Tue, 26 Jul 2011 21:05:16 -0700
Message-Id: <1311739521-11014-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311739521-11014-1-git-send-email-gregkh@suse.de>
References: <20110726045707.GA2321@kroah.com>
 <1311739521-11014-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The kernel configuration UEVENT_HELPER_PATH is a string to
the uevent helper program. Add more description about how
to disable this feature and how to enable it again during
runtime.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 52c6758..fa64fa0 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -16,6 +16,11 @@ config UEVENT_HELPER_PATH
 	  that it creates a high system load, or on smaller systems
 	  it is known to create out-of-memory situations during bootup.
 
+	  To disable user space helper program execution at early boot
+	  time specify an empty string here. This setting can be altered
+	  via /proc/sys/kernel/hotplug or via /sys/kernel/uevent_helper
+	  later at runtime.
+
 config DEVTMPFS
 	bool "Maintain a devtmpfs filesystem to mount at /dev"
 	depends on HOTPLUG
-- 
1.7.6

