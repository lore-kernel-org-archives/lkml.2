Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab1ASITo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:19:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56697 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1ASITl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:19:41 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>, charu@ti.com,
        sshtylyov@mvista.com
Subject: [PATCHv4 0/4] omap3: Devkit8000: misc fixes
Date: Wed, 19 Jan 2011 09:19:22 +0100
Message-Id: <1295425166-25540-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
X-Provags-ID: V02:K0:Loos+2SlwTZGJXR2pE4e1t9oiMdgX6n50pzaR53g58s
 1KnBuxHT5WTyiZGhJj2Cz021fxT4ZYUh++EUd2v5WIFdyPgrMb
 Mb81iIQtm7y/Q8FaK1u3AJHCRjEp8aGRs/2/9tF1uc4Y//plLc
 woDiZSYAvZ/+PtwrYAcbwFi3R+5mUIYleF+BZMJLUFx6mw4tku
 2xKknlcniESxaxaPMJo7g==
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

Changed from v3:
	Use return value of gpio_request.
	Fix indentation of one curly brace.

Daniel Morsing (1):
  OMAP3: Devkit8000: Fix tps65930 pullup/pulldown configuration

Thomas Weber (3):
  OMAP3: Devkit8000: Change lcd power pin
  OMAP3: Devkit8000: Check return value of gpio_request
  OMAP3: Devkit8000: Fix indentation

 arch/arm/mach-omap2/board-devkit8000.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

-- 
1.7.4.rc2

