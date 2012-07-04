Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab2GDIoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:44:34 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50050 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2GDIo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:44:29 -0400
MIME-Version: 1.0
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 4 Jul 2012 16:44:08 +0800
X-Google-Sender-Auth: 4xkKT3LG-w0h59bN7oD4t7E-LAs
Message-ID: <CAK5ve-JkMhKwr9kYv6Tbu0XdCZi=UnhfXGSRsxRL1J5KN3v8kA@mail.gmail.com>
Subject: [GIT PULL] leds fix for 3.5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider to merge this fix for heartbeat led trigger driver.

The following changes since commit 9e85a6f9dc231f3ed3c1dc1b12217505d970142a:

  Merge tag 'clk-fixes-for-linus' of
git://git.linaro.org/people/mturquette/linux (2012-07-03 18:06:49
-0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
fixes-for-3.5

for you to fetch changes up to fb31fbeb647ed1910290712c13f11f1db09e5506:

  leds: heartbeat: fix bug on panic (2012-07-04 15:55:19 +0800)

----------------------------------------------------------------
Alexander Holler (1):
      leds: heartbeat: fix bug on panic

 drivers/leds/ledtrig-heartbeat.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)
~
~
