Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0DNPci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:32:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46631 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab0DNPch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:32:37 -0400
From: "Arce, Abraham" <x0066660@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 14 Apr 2010 10:32:35 -0500
Subject: [PATCH] Documentation: SubmittingDrivers: Resources
Thread-Topic: [PATCH] Documentation: SubmittingDrivers: Resources
Thread-Index: Acrb57TxRm60akfiQkK/1FWxeZPuIw==
Message-ID: <27F9C60D11D683428E133F85D2BB4A53043D9EEB84@dlee03.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add additional location (Git) for the kernel master tree
- Add reference to Git Project

Signed-off-by: Abraham Arce <x0066660@ti.com>
---
 Documentation/SubmittingDrivers |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/SubmittingDrivers b/Documentation/SubmittingDrivers
index 99e72a8..1ed68d1 100644
--- a/Documentation/SubmittingDrivers
+++ b/Documentation/SubmittingDrivers
@@ -130,6 +130,8 @@ Linux kernel master tree:
 	ftp.??.kernel.org:/pub/linux/kernel/...
 	?? == your country code, such as "us", "uk", "fr", etc.
 
+	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git
+
 Linux kernel mailing list:
 	linux-kernel@vger.kernel.org
 	[mail majordomo@vger.kernel.org to subscribe]
@@ -160,3 +162,7 @@ How to NOT write kernel driver by Arjan van de Ven:
 
 Kernel Janitor:
 	http://janitor.kernelnewbies.org/
+
+GIT, Fast Version Control System:
+	http://git-scm.com/
+
-- 
1.5.4.3

