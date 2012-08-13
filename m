Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2HMGuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 02:50:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56464 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2HMGuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 02:50:02 -0400
MIME-Version: 1.0
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 13 Aug 2012 14:49:40 +0800
X-Google-Sender-Auth: BuERa-fEfwNbr4YBbn7-F5I6aoI
Message-ID: <CAK5ve-LhsH0WgU05rJ936xyc2DuMq-WfsgyckRgO_UOAzW+QJg@mail.gmail.com>
Subject: [GIT PULL] leds fix for 3.6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider the following changes since commit
0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
fixes-for-3.6

for you to fetch changes up to 4a5a4184628c529774c1492bc1a21743b69b5fc3:

  leds: renesas: fix error handling (2012-08-13 14:34:02 +0800)

----------------------------------------------------------------
Arnd Bergmann (1):
      leds: renesas: fix error handling

Axel Lin (1):
      leds: lp8788: Fix updating scale configuration bits

Fabio Baltieri (1):
      Revert "leds: use led_set_brightness in led_trigger_event"

 drivers/leds/led-triggers.c     | 2 +-
 drivers/leds/leds-lp8788.c      | 2 +-
 drivers/leds/leds-renesas-tpu.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)
