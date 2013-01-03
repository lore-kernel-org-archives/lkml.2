Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3ACBvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:51:12 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:54658 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3ACBvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:51:09 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 2 Jan 2013 17:50:47 -0800
Message-ID: <CAK5ve-+rpsqfY4_UjtT5X4KKrOf+NPT6Lo6p-4+j0zi3xLmJzw@mail.gmail.com>
Subject: [GIT PULL] a LED fix for 3.8
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please consider the following changes since commit
a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
fixes-for-3.8

for you to fetch changes up to c36f03f2c4b6c02166a217a71e072603ee33423e:

  leds: leds-gpio: set devm_gpio_request_one() flags param correctly
(2013-01-02 17:03:49 -0800)

----------------------------------------------------------------
Javier Martinez Canillas (1):
      leds: leds-gpio: set devm_gpio_request_one() flags param correctly

 drivers/leds/leds-gpio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
