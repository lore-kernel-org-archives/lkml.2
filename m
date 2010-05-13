Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0EMH5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:57:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35759 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab0EMH5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PYUM0BMFNSSrsNTNpcsz3HGEh0zU6bm1JYioFUt4VRebyBKaHN5D/0DMUPwJyyAZHc
         rwiNLYohzr1uHEZwGfK8ObigsO1ledPEbltUWr4EKbnVpYmTLEWcLuu4SCPKzLY7HyZo
         POSJAXIXZ/3Iy61XZ3O1WLC5cX7OmzPK5OUdw=
Date: Thu, 13 May 2010 00:57:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100513075728.GF30110@core.coreip.homeip.net>
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

to receive a few last minute changes to the input subsystem.

Changelog:
---------

Bastien Nocera (1):
      Input: i8042 - do not try to probe ports on Intel Apple Macs

Dmitry Torokhov (2):
      Input: elantech - use all 3 bytes when checking version
      Input: psmouse - reset all types of mice before reconnecting

Marek Vasut (2):
      Input: iforce - add Guillemot Jet Leader Force Feedback
      Input: iforce - fix Guillemot Jet Leader 3D entry

Oskar Schirmer (1):
      Input: ad7877 - keep dma rx buffers in seperate cache lines


Diffstat:
--------

 drivers/input/joystick/iforce/iforce-main.c |    6 ++++-
 drivers/input/joystick/iforce/iforce-usb.c  |    1 +
 drivers/input/mouse/elantech.c              |   24 ++++++++++----------
 drivers/input/mouse/elantech.h              |    5 +--
 drivers/input/mouse/psmouse-base.c          |   14 +++++++++---
 drivers/input/serio/i8042-x86ia64io.h       |   30 ++++++++++++++++++++++++++-
 drivers/input/touchscreen/ad7877.c          |   15 ++++++++++--
 7 files changed, 71 insertions(+), 24 deletions(-)

-- 
Dmitry

