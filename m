Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab1ACQk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:40:29 -0500
Received: from sd-11162.dedibox.fr ([88.191.70.230]:57754 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab1ACQkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:40:15 -0500
Date: Mon, 3 Jan 2011 17:40:12 +0100
From: Stelian Pop <stelian@popies.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove myself from MAINTAINERS as I no longer have the
 hardware to test.
Message-ID: <20110103164011.GD7475@calypso>
Reply-To: Stelian Pop <stelian@popies.net>
Mail-Followup-To: Stelian Pop <stelian@popies.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is PPC only, and I am no longer able to test it.

Signed-off-by: Stelian Pop <stelian@popies.net>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1a1c27b..61d8c41 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -429,7 +429,6 @@ S:	Supported
 F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
-M:	Stelian Pop <stelian@popies.net>
 M:	Michael Hanselmann <linux-kernel@hansmi.ch>
 S:	Supported
 F:	drivers/macintosh/ams/
-- 
1.7.1
