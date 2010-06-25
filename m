Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab0FYQC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 12:02:27 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57946 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0FYQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 12:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Kk3AZ6+zbu1efoQiTOKfKnv8C+TDAcHuWIJ0jstwfZykL1ROynE6UQaye0W3Vwem5a
         dy5YkOlDH0lbFY2MfBpqXiK3mPKkbPhpWVnrJ0XYHlxf/mFNx752Rchh0ZPy7QVwEQ1m
         bisS3T/8Yg4pkA9QsTn2+MRMziiNHpm8aIFxw=
Date: Fri, 25 Jun 2010 09:02:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.35-rc1
Message-ID: <20100625160218.GA18302@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem that mainly fix issues arisen from
the recent pull.


Changelog:
---------

Dan Carpenter (1):
      Input: pcf8574_keypad - fix off by one in pcf8574_kp_irq_handler()

Dmitry Torokhov (1):
      Input: sysrq - fix "stuck" SysRq mode

Henrik Rydberg (1):
      MAINTAINERS - Add an entry for the input MT protocol

Oskar Schirmer (1):
      Input: ad7877 - fix spi word size to 16 bit

Ping Cheng (1):
      Input: wacom - fix serial number handling on Cintiq 21UX2

Randy Dunlap (1):
      Input: fixup X86_MRST selects


Diffstat:
--------

 MAINTAINERS                         |    7 +++++++
 drivers/char/sysrq.c                |    8 ++++++--
 drivers/input/keyboard/Kconfig      |    2 +-
 drivers/input/misc/pcf8574_keypad.c |    2 +-
 drivers/input/serio/Kconfig         |    2 +-
 drivers/input/tablet/wacom_wac.c    |    9 +++++----
 drivers/input/touchscreen/ad7877.c  |    7 +++++++
 7 files changed, 28 insertions(+), 9 deletions(-)

-- 
Dmitry

