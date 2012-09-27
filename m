Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2I0Fhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:37:46 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48826 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab2I0Fho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:37:44 -0400
MIME-Version: 1.0
Date: Thu, 27 Sep 2012 07:37:43 +0200
Message-ID: <CACRpkdYQ2gXhrpG=_8Q2-q2UqTpJ2fS0fU46yfEs3VCQGNZRhQ@mail.gmail.com>
Subject: [GIT PULL] late gpio fix for v3.6
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a late fix for the GPIO subsystem from Roland Stigge. This one is
going into the stable series so no point in holding it back.

Please pull it in!

Yours,
Linus Walleij

The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-fixes-v3.6

for you to fetch changes up to b1268d3737c6316016026245eef276eda6b0a621:

  gpio-lpc32xx: Fix value handling of gpio_direction_output()
(2012-09-24 21:56:01 +0200)

----------------------------------------------------------------
A lates GPIO fix: Roland Stigge found a problem in the LPC32xx
driver where a callback ignores one of its arguments. It needs
to go into stable too so sending this upstream immediately.

----------------------------------------------------------------
Roland Stigge (1):
      gpio-lpc32xx: Fix value handling of gpio_direction_output()

 drivers/gpio/gpio-lpc32xx.c | 5 +++++
 1 file changed, 5 insertions(+)
