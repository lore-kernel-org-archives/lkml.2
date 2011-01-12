Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1ALGKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:10:05 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61082 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1ALGKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WaKIVLEdRdEh4jwGdj0jkGtBQUWib+2y8S2fzALXL+SryOXkfncvWZbiT2oYDja+zw
         EthxTw7ZE4EvAyLfCEOeE1NQ6xN6JwZRzMNrOzxfRDrZrDsm1nJx9kKY71kEtUuknEwb
         N7+b1lWPOPD2/bBslRilV8obDJ5+LkDUKVdAY=
Date: Tue, 11 Jan 2011 22:09:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.38-rc0 (round 2)
Message-ID: <20110112060954.GE22944@core.coreip.homeip.net>
References: <20110107065448.GC29038@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107065448.GC29038@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2nd round of updates for the input subsystem. One driver out,
one driver in, and a bunch of minor fixes.

Thanks!

Changelog:
---------

Alexander Stein (1):
      Input: fix force feedback capability query example

Fabien Marteau (1):
      Input: add Austria Microsystem AS5011 joystick driver

Jamie Iles (1):
      Input: remove aaed2000 keyboard driver

Jekyll Lai (1):
      Input: add SW_ROTATE_LOCK switch type

Jiri Kosina (1):
      Input: i8042 - introduce 'notimeout' blacklist for Dell Vostro V13

Mark Brown (5):
      Input: ad7879 - convert I2C to dev_pm_ops
      Input: eeti_ts - convert to dev_pm_ops
      Input: mcs5000_ts - convert to dev_pm_ops
      Input: migor_ts - convert to dev_pm_ops
      Input: cy8ctmg110_ts - Convert to dev_pm_ops

Ping Cheng (1):
      Input: wacom_w8001 - add single-touch support


Diffstat:
--------

 Documentation/input/ff.txt                |    4 +-
 Documentation/kernel-parameters.txt       |    1 +
 drivers/input/joystick/Kconfig            |   10 +
 drivers/input/joystick/Makefile           |    1 +
 drivers/input/joystick/as5011.c           |  367 +++++++++++++++++++++++++++++
 drivers/input/keyboard/Kconfig            |   12 -
 drivers/input/keyboard/Makefile           |    1 -
 drivers/input/keyboard/aaed2000_kbd.c     |  186 ---------------
 drivers/input/serio/i8042-x86ia64io.h     |   21 ++
 drivers/input/serio/i8042.c               |    6 +-
 drivers/input/touchscreen/ad7879-i2c.c    |   17 +-
 drivers/input/touchscreen/cy8ctmg110_ts.c |   15 +-
 drivers/input/touchscreen/eeti_ts.c       |   16 +-
 drivers/input/touchscreen/mcs5000_ts.c    |   17 +-
 drivers/input/touchscreen/migor_ts.c      |   12 +-
 drivers/input/touchscreen/wacom_w8001.c   |  182 ++++++++++++---
 include/linux/input.h                     |    1 +
 include/linux/input/as5011.h              |   20 ++
 18 files changed, 624 insertions(+), 265 deletions(-)
 create mode 100644 drivers/input/joystick/as5011.c
 delete mode 100644 drivers/input/keyboard/aaed2000_kbd.c
 create mode 100644 include/linux/input/as5011.h

-- 
Dmitry
