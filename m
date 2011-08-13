Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1HMA1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:27:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53640 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1HMA1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:27:42 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 03/10]Documentation:usb:linux.inf Remove pointless "@" from various parts of the kernel
Date: Fri, 12 Aug 2011 17:27:08 -0700
Message-Id: <1313195235-4522-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch series below removes some pointless "@"'s in various parts of the kernel.
Note: some might be useful, but then again, some just seemed a waste of space.
(and since the kernel is become bloated, might as well diet! even if it's a few bits)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/usb/linux.inf |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/usb/linux.inf b/Documentation/usb/linux.inf
index 4ffa715b0..8240a1e 100644
--- a/Documentation/usb/linux.inf
+++ b/Documentation/usb/linux.inf
@@ -28,7 +28,7 @@ DriverVer           = 06/21/2006,6.0.6000.16384
 [LinuxDevices.NTia64]
 %LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_1d6b&PID_0104&MI_00
 
-;@@@ This is the common setting for setup
+; This is the common setting for setup
 [ControlFlags]
 ExcludeFromSelect=*
 
-- 
1.7.6

