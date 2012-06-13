Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab2FMEli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 00:41:38 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35022 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2FMElh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 00:41:37 -0400
MIME-Version: 1.0
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 13 Jun 2012 12:41:15 +0800
X-Google-Sender-Auth: NWmgrBtpA9SPBzLTdBgEhtkDwzc
Message-ID: <CAK5ve-L08mx3-wwpaXOjoaTBnOEgCFS3RqprQ+Jg0gUoqNY_zw@mail.gmail.com>
Subject: [GIT PULL] LED subsystem fixes for 3.5-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please consider the following changes since commit
cfaf025112d3856637ff34a767ef785ef5cf2ca9:

  Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
fixes-for-3.5

for you to fetch changes up to 9473c4c16700ec965904f23234fd0f8677ce6231:

  leds: Make LEDS_ASIC3 and LEDS_RENESAS_TPU depend on LEDS_CLASS=y
(2012-06-12 10:56:25 +0800)

----------------------------------------------------------------
Axel Lin (1):
      leds: Make LEDS_ASIC3 and LEDS_RENESAS_TPU depend on LEDS_CLASS=y

Jeffrin Jose (1):
      leds: fixed a coding style issue.

Rafal Prylowski (1):
      leds: don't disable blinking when writing the same value to
delay_on or delay_off

 drivers/leds/Kconfig     |    4 ++--
 drivers/leds/led-class.c |    2 +-
 drivers/leds/led-core.c  |    7 -------
 3 files changed, 3 insertions(+), 10 deletions(-)

-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
