Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1BPGQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:16:48 -0500
Received: from mout.perfora.net ([74.208.4.194]:51129 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab1BPGQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:16:46 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: =?utf-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>, Stephen Wilson <wilsons@start.ca>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rc: do not enable remote controller adapters by default.
Date: Wed, 16 Feb 2011 01:16:12 -0500
Message-ID: <m3aahwa4ib.fsf@fibrous.localdomain>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V02:K0:JONDYYPGOGxhC0oAJQ087aOiyfTCUrB92u1sDc9ZEnz
 MfXz3Yl8GO3Sgh8kmTeehYtwVH/A166W1rTUZIm0qlYCPnK1K/
 r9e71BRZm1UohYn0nzqT2OLrDnhmjQpLpcE9tCFvZf3smvcS6Q
 y4eyxRgHcHx9LlavmNLs2ERpp9NXrjLO7P24lsyE7iEjF9Tuxf
 AZbdd9sglCHAomS9sS6FS7JZhxKbhm09UfSLdG0dxU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Having the RC_CORE config default to INPUT is almost equivalent to
saying "yes".  Default to "no" instead.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 drivers/media/rc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 3785162..8842843 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -1,7 +1,7 @@
 menuconfig RC_CORE
 	tristate "Remote Controller adapters"
 	depends on INPUT
-	default INPUT
+	default n
 	---help---
 	  Enable support for Remote Controllers on Linux. This is
 	  needed in order to support several video capture adapters.
--
1.7.3.5
