Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1HDHxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 03:53:33 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44519 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1HDHx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 03:53:28 -0400
Date: Thu, 4 Aug 2011 00:53:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.1-rc0
Message-ID: <20110804075321.GA31276@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Just random driver fixes,
nothing too interesting.

Thanks!

Changelog:
---------

Axel Lin (1):
      Input: lm8323 - add missing device_remove_file for dev_attr_time

Michael Hennerich (1):
      Input: ad7879 - fix deficient device disable

Rakesh Iyer (1):
      Input: tegra-kbc - fix computation of polling time

Randy Dunlap (1):
      Input: psmouse - hgpk.c needs module.h

Shawn Guo (1):
      Input: mma8450 - add device tree probe support

Stephen Rothwell (1):
      Input: kxtj9 - explicitly include module.h

Tobias Klauser (2):
      Input: gpio_keys - return proper error code if memory allocation fails
      Input: gpio_keys - fix two typos in devicetree documentation


Diffstat:
--------

 .../devicetree/bindings/gpio/gpio_keys.txt         |    2 +-
 .../devicetree/bindings/input/fsl-mma8450.txt      |   11 +++++++++++
 drivers/input/keyboard/gpio_keys.c                 |    2 +-
 drivers/input/keyboard/lm8323.c                    |    9 +++++++--
 drivers/input/keyboard/tegra-kbc.c                 |    5 +++--
 drivers/input/misc/kxtj9.c                         |    1 +
 drivers/input/misc/mma8450.c                       |    8 ++++++++
 drivers/input/mouse/hgpk.c                         |    1 +
 drivers/input/touchscreen/ad7879.c                 |    4 +++-
 9 files changed, 36 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/fsl-mma8450.txt

-- 
Dmitry

