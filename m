Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab2AMPUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:20:16 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:49069 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758297Ab2AMPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:20:13 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/8] DB8500 PRCMU update
Date: Fri, 13 Jan 2012 16:19:46 +0100
Message-ID: <1326467986-11648-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is a set of updates to the DB8500 driver that mainly expand
clock handling and tries to get a more clean approach to the
various register access. This is targeted at next (v3.4) merge
window, but we'd like to see it mature in linux-next as soon as
possible so I'm sending it early.

Yours,
Linus Walleij

Bengt Jonsson (1):
  mfd/db8500-prcmu: spawned regulators update

Daniel Willerud (1):
  mfd/db8500-prcmu: remove U8400 legacy

Jonas Aaberg (1):
  mfd/db8500-prcmu: remove check for firmware bug

Mattias Nilsson (5):
  mfd/db8500-prcmu: function for obtaining the prcmu firmware version
  mfd/db8500-prcmu: update abstract dbx500 interface
  mfd/db8500-prcmu: clock handling update
  mfd/db8500-prcmu: OPP and sleep handling update
  mfd/db8500-prcmu: add initial prcmu register access api

 drivers/cpufreq/db8500-cpufreq.c |   13 +-
 drivers/mfd/db8500-prcmu.c       |  927 ++++++++++++++++++++++++++++++--------
 drivers/mfd/dbx500-prcmu-regs.h  |  128 ++++--
 include/linux/mfd/db8500-prcmu.h |  142 ++++--
 include/linux/mfd/dbx500-prcmu.h |  359 ++++++++++++++-
 5 files changed, 1272 insertions(+), 297 deletions(-)

-- 
1.7.8

