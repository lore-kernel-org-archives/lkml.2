Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2DQHsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:48:53 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:37414 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793Ab2DQHsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:48:52 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/6] MFD: ab8500 updates for -next
Date: Tue, 17 Apr 2012 09:29:57 +0200
Message-ID: <1334647797-1588-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Here are some functional updates for the AB8500 driver for
the next merge window, these should be orthogonal to the
removal of AB5500.

Jonas Aaberg (2):
  mfd/ab8500: deny suspend if i2c transfer is ongoing
  mfd/ab8500: print switch off cause

Michel JAOUEN (1):
  mfd/ab8500: support of hierachical interrupt

Rabin Vincent (1):
  mfd/ab8500: handle the irq for suspend/resume

Rickard Andersson (1):
  mfd/ab8500: add parameter to disable battery management

Virupax Sadashivpetimath (1):
  mfd/ab8500: add new resources on AB8505 and AB9540

 drivers/mfd/ab8500-core.c         |  263 ++++++++++++++++++++++++++++++++-----
 drivers/mfd/ab8500-i2c.c          |   32 +++++
 include/linux/mfd/abx500/ab8500.h |   18 ++-
 3 files changed, 274 insertions(+), 39 deletions(-)

-- 
1.7.9.2

