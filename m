Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab0E0QV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:21:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56755 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab0E0QVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:21:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=w1K6xjhSrBpFQZkwQ/Pzzx0Yd0+17PCAlGUdJQcF8HJufrt57KwHzlDOeFFt8OrkUy
         P8sPHjDatXlKvOy50rZ5Sh1NX0R6aRF64Ewv+tF7+CENERDvJ8emKOtkizOSSR9mBEtw
         jpjrdcOfHzo6czk2+0VMLw6VnqfR9O3wPAmGM=
Date: Thu, 27 May 2010 09:14:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.35-rc0
Message-ID: <20100527161455.GA558@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive some more updates for the input subsystem.

Changelog:
---------

Daniel Mack (1):
      Input: use ABS_CNT rather than (ABS_MAX + 1)

Haojian Zhuang (1):
      Input: enable onkey driver of max8925

Kevin Hilman (1):
      Input: ads7846 - return error on regulator_get() failure

Ondrej Zary (1):
      Input: usbtouchscreen - support bigger iNexio touchscreens

Peter Ujfalusi (1):
      Input: twl4030-vibra - correct the power down sequence


Diffstat:
--------

 drivers/hid/hid-debug.c                    |    2 +-
 drivers/input/joydev.c                     |   10 +-
 drivers/input/misc/Kconfig                 |   10 ++
 drivers/input/misc/Makefile                |    1 +
 drivers/input/misc/max8925_onkey.c         |  148 ++++++++++++++++++++++++++++
 drivers/input/misc/twl4030-vibra.c         |    2 +-
 drivers/input/misc/uinput.c                |    4 +-
 drivers/input/touchscreen/ads7846.c        |    4 +-
 drivers/input/touchscreen/usbtouchscreen.c |    7 +-
 include/linux/input.h                      |   12 +-
 include/linux/joystick.h                   |    4 +-
 include/linux/uinput.h                     |   10 +-
 12 files changed, 189 insertions(+), 25 deletions(-)
 create mode 100644 drivers/input/misc/max8925_onkey.c

-- 
Dmitry

