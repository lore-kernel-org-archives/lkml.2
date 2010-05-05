Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0EEGll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 02:41:41 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:38065 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab0EEGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 02:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OedLcX9/CSHxCQlgTUR6pU1tVb4DlIpDOiYl6FFZwHKj+k9bF4LG1tBDuZKaWF2zeh
         rO8y0z8xgp7x5lmauHoXFa8/MgL/sf2aF8lBrDZ+34kcD2NNReWv9+AhJLRPHMxX4xhX
         gR/wZ/kQp68HcIdNjsQWIALqWfYT7NQa+2Guw=
Date: Tue, 4 May 2010 23:41:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100505064133.GA12329@core.coreip.homeip.net>
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

to receive updates for the input subsystem. Nothing super exciting but
owners of newer touchpads will get a bit happier.

Changelog:
---------

Christoph Fritz (1):
      Input: joydev - allow binding to button-only devices

Daniel Mack (1):
      Input: eeti_ts - cancel pending work when going to suspend

Dmitry Torokhov (2):
      Input: psmouse - ignore parity error for basic protocols
      Revert "Input: ALPS - add signature for HP Pavilion dm3 laptops"

Florian Ragwitz (3):
      Input: elantech - fix firmware version check
      Input: elantech - allow forcing Elantech protocol
      Input: elantech - ignore high bits in the position coordinates

Jarod Wilson (1):
      Input: ati_remote - add some missing devices from lirc_atiusb

Takashi Iwai (1):
      Input: Add support of Synaptics Clickpad device


Diffstat:
--------

 Documentation/input/elantech.txt    |    8 ++--
 drivers/input/joydev.c              |   18 +++++++
 drivers/input/misc/ati_remote.c     |   14 ++++--
 drivers/input/mouse/alps.c          |    1 -
 drivers/input/mouse/elantech.c      |   84 +++++++++++++++++++++++------------
 drivers/input/mouse/psmouse-base.c  |   18 ++++++-
 drivers/input/mouse/psmouse.h       |    1 +
 drivers/input/mouse/synaptics.c     |   35 ++++++++++++--
 drivers/input/mouse/synaptics.h     |    4 ++
 drivers/input/touchscreen/eeti_ts.c |   56 +++++++++++++++++++----
 10 files changed, 183 insertions(+), 56 deletions(-)

-- 
Dmitry

