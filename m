Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1BBQcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:32:17 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:38669 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959Ab1BBQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:32:16 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 0/2] ARM IRQ Kconfig Changes
Date: Wed,  2 Feb 2011 18:31:53 +0200
Message-Id: <1296664315-32108-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.4.rc2
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches are simple fixes,
the first one fixes a mistake on a previous
commit and the second one lets OMAP use sparse
IRQ numbering scheme.

Boot tested on pandaboard. Note that this is a
rebased version of older patchset [1] which was
resent later [2] but nobody took action on those.

Andrew, would you take care of these two patches
for me provided Tony and Russell are ok with them ?

[1] http://marc.info/?l=linux-omap&m=129414258508740&w=2
[2] http://marc.info/?l=linux-omap&m=129550582206489&w=2

Felipe Balbi (2):
  arm: Kconfig: select correct HAVE_SPARSE_IRQ symbol
  arm: Kconfig: allow OMAP to use sparse IRQ numbering

 arch/arm/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

-- 
1.7.4.rc2

