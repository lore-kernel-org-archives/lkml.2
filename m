Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1ARG7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:59:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52344 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1ARG7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:59:01 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>
Subject: [PATCHv3 0/2] omap3: Devkit8000: misc fixes
Date: Tue, 18 Jan 2011 07:58:50 +0100
Message-Id: <1295333932-23935-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
X-Provags-ID: V02:K0:us/Q90ZVOEpMlJWIVCOmP3DoN2cH/hqxvLyYi8nJYWP
 tn1Bvtg+UbTHMi0z9iBnVdfuftorS49CdKSv7D2ZxU0SzOPNws
 1X2y47h0PfPZqpfINmLtxG+Fm5QnaCkwsahcZwpt+RLncmXqwc
 9mFqkrnipMpQRNHZYnNxoPVfXMJSS5I5mtr/0bgJHbtOIt6/6k
 4Ttj0sghDt1ynmlVrdW2w==
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

Changes from v2:
	Better comment for removing low level functions used for twl4030 gpio
	Fix indention => indentation in comment

Daniel Morsing (1):
  OMAP3: Devkit8000: Fix tps65930 pullup/pulldown configuration

Thomas Weber (1):
  OMAP3: Devkit8000: Change lcd power pin

 arch/arm/mach-omap2/board-devkit8000.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

-- 
1.7.4.rc2

