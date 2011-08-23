Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab1HWR24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:28:56 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:47565 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab1HWR2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:28:51 -0400
From: Bart Van Assche <bvanassche@acm.org>
Reply-To: bvanassche@acm.org
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2, v3] docs/driver-model: Update device class docs
Date: Tue, 23 Aug 2011 19:28:43 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.1-1.2-default; KDE/4.6.0; x86_64; ; )
Cc: linux-doc@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>, rpearson@systemfabricworks.com
References: <201108231927.27765.bvanassche@acm.org>
In-Reply-To: <201108231927.27765.bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108231928.43906.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver model documentation was added to the kernel tree before
struct class was added to <linux/device.h>. Hence this patch that
updates the paragraph about struct class in
Documentation/driver-model/binding.txt.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/driver-model/binding.txt |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/Documentation/driver-model/binding.txt b/Documentation/driver-model/binding.txt
index f7ec9d6..abfc8e2 100644
--- a/Documentation/driver-model/binding.txt
+++ b/Documentation/driver-model/binding.txt
@@ -48,10 +48,6 @@ devclass_add_device is called to enumerate the device within the class
 and actually register it with the class, which happens with the
 class's register_dev callback.
 
-NOTE: The device class structures and core routines to manipulate them
-are not in the mainline kernel, so the discussion is still a bit
-speculative. 
-
 
 Driver
 ~~~~~~
-- 
1.7.3.4

