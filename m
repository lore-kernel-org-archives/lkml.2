Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab0JDUdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:33:12 -0400
Received: from www17.your-server.de ([213.133.104.17]:54179 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab0JDUdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:33:10 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [drm:init_ring_common] *ERROR* render ring head not reset to zero
Date: Mon, 4 Oct 2010 22:31:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-00119-g3c06806; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010042231.20320.thomas@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happens in 2.6.36-rcX:

[    0.523130] [drm] Initialized drm 1.1.0 20060810
[    0.523159] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.523165] i915 0000:00:02.0: setting latency timer to 64
[    0.555999] [drm] detected 63M stolen memory, trimming to 32M
[    0.556065] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.556077] [drm] set up 32M of stolen space
[    0.556247] [drm:init_ring_common] *ERROR* render ring head not reset to zero ctl 00000000 head 02001000 tail 00000000 start 02001000
[    0.556320] [drm:init_ring_common] *ERROR* render ring head forced to zero ctl 00000000 head 00000000 tail 00000000 start 02001000

Bug or feature?
