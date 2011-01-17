Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1AQOMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:12:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51022 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1AQOMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:12:20 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>
Subject: [PATCHv2 0/2] misc Devkit8000 fixes
Date: Mon, 17 Jan 2011 15:11:57 +0100
Message-Id: <1295273519-6189-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
X-Provags-ID: V02:K0:x3f2VLYn31cJoQf6dwnwd/K2mNiUO9tdVqJUgsuqjKw
 lvSR7KFxeWF3v3toXK2tc1sib//7zu7VA/9XQxElb4yzOVxp+2
 57VQIb7BrfBvaaUDzmr+wLF2tb0O1bes0ifBSD3hJ7FZlnNnqD
 4g46hPogRfycWQVsAr2L5+2PT9wubvi9Q38y4hg7+xlphB9UYe
 5y2KII+UGn+9255Xfhzsg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a set of misc fixes for the devkit8000.

The only really notable one is the lcd enable gpio fix. It gets rid
of some nasty low level twl4030 calls and replaces them with generic gpio
calls. It also fixes a bug where the screen would not turn off when
blanking.

Changes from v1: 
	Pull the indention fix into "Change lcd power pin".
	Change the pin for lcd pwren.
	Fix the pullup/pulldown configuration after lcd prwen correction.

Daniel Morsing (1):
  omap3: devkit8000: fix tps65930 pullup/pulldown configuration

Thomas Weber (1):
  OMAP3: Devkit8000: Change lcd power pin

 arch/arm/mach-omap2/board-devkit8000.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

-- 
1.7.4.rc2

