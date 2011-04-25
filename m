Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab1DYWPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 18:15:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61191 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab1DYWPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 18:15:12 -0400
MIME-Version: 1.0
Date: Tue, 26 Apr 2011 00:15:11 +0200
Message-ID: <BANLkTinzMvy04Oh7M4AQmK-OVma6ADb50w@mail.gmail.com>
Subject: [GIT PULL] u300 and ux500 regression fixes for .39 series
From: Linus Walleij <linus.walleij@linaro.org>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are two fixes that makes u300 and ux500 boot on the
2.6.39 series. They have been sent to the appropriate mailing
lists but haven't got any comments for a week or so. Please
pull them in.

The following changes since commit f0e615c3cb72b42191b558c130409335812621d8:

  Linux 2.6.39-rc4 (2011-04-18 21:26:00 -0700)

are available in the git repository and branch at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git
for-torvalds

Linus Walleij (2):
      mach-ux500: fix i2c0 device setup regression
      rtc: fix coh901331 startup crash

 arch/arm/mach-ux500/board-mop500.c |   19 ++++++++++---------
 drivers/rtc/rtc-coh901331.c        |    4 ++--
 2 files changed, 12 insertions(+), 11 deletions(-)
