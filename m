Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0DOS1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:27:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51044 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0DOS1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DjFVGSgZNvjIw2AIAA61Voaxz/BfKQ6grzyqNI8C0YxOBMsZectji9bYmdP1iu355v
         tQL7m6oFJSPt8YUW7TLa3QN6E9a+hhh5DbPMWuExRo43vOqnzRJJoDlVVG44bLf3m7XN
         uZ1QgtHz6MntdCvxz/iINYzwkmRyq1HfJOIDY=
Date: Thu, 15 Apr 2010 11:27:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.34-rc3
Message-ID: <20100415182708.GA17514@core.coreip.homeip.net>
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

to receive updates for the input subsystem. This adds a couple of
patches to my previous pull request for -rc3 that it seems you have
missed. Thanks!

Changelog:
---------

Chase Douglas (1):
      Input: ALPS - add signature for HP Pavilion dm3 laptops

Dmitry Torokhov (2):
      Input: sparse-keymap - implement safer freeing of the keymap
      Revert "Input: wacom - merge out and in prox events"

Dominik Brodowski (1):
      Input: i8042 - spelling fix

H Hartley Sweeten (1):
      Input: matrix_keypad - allow platform to disable key autorepeat

Henrik Rydberg (3):
      Input: bcm5974 - retract efi-broken suspend_resume
      Input: clarify the no-finger event in multitouch protocol
      Input: update the status of the Multitouch X driver project

Ping Cheng (1):
      Input: wacom - switch mode upon system resume

Yong Wang (1):
      Input: sparse-keymap - free the right keymap on error


Diffstat:
--------

 Documentation/input/multi-touch-protocol.txt |   23 +++-
 drivers/input/input.c                        |    9 ++-
 drivers/input/keyboard/matrix_keypad.c       |    4 +-
 drivers/input/mouse/alps.c                   |    1 +
 drivers/input/mouse/bcm5974.c                |    1 -
 drivers/input/serio/i8042.c                  |    2 +-
 drivers/input/sparse-keymap.c                |   52 +++++---
 drivers/input/tablet/wacom_sys.c             |   12 +-
 drivers/input/tablet/wacom_wac.c             |  163 ++++++++++++++++---------
 include/linux/input/matrix_keypad.h          |    2 +
 10 files changed, 176 insertions(+), 93 deletions(-)

-- 
Dmitry

