Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2KLSeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 13:34:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35248 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2KLSeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:34:02 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
User-Agent: alot/0.3.2+
To: torvalds@linux-foundation.org
Message-ID: <20121112183341.17970.71457@nucleus>
Subject: common clk fixes for 3.7-rc6
Date: Mon, 12 Nov 2012 10:33:41 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to 3d930678034e756d0960d214412d344772b21109:

  clk: ux500: Register slimbus clock lookups for u8500 (2012-11-12 10:20:23 -0800)

----------------------------------------------------------------
Missing clkdev entries are causing regressions on the U8500 platform.
This pull request contains those missing clkdev entries which are needed
to boot that platform.

----------------------------------------------------------------
Ulf Hansson (5):
      clk: ux500: Register i2c clock lookups for u8500
      clk: ux500: Register ssp clock lookups for u8500
      clk: ux500: Register msp clock lookups for u8500
      clk: ux500: Update rtc clock lookup for u8500
      clk: ux500: Register slimbus clock lookups for u8500

 drivers/clk/ux500/u8500_clk.c |   50 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)
