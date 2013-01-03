Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3ACCIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 21:08:46 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:64875 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3ACCIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 21:08:43 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 2 Jan 2013 18:08:21 -0800
Message-ID: <CAK5ve-+4fZEaOWNPdmry7OcytFBG7b_KArxLo38yKNWkcarH7Q@mail.gmail.com>
Subject: [GIT PULL] a LED fix for 3.8 (try2)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
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

for you to fetch changes up to 2d7c22f67d5c342a6296127af4f224208449b779:

  leds: leds-gpio: set devm_gpio_request_one() flags param correctly
(2013-01-02 17:58:41 -0800)

----------------------------------------------------------------
Javier Martinez Canillas (1):
      leds: leds-gpio: set devm_gpio_request_one() flags param correctly

 drivers/leds/leds-gpio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
