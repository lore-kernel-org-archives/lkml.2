Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0DFGbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 02:31:08 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:35578 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0DFGa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 02:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lVR+5Gx1uXb/AFZsXbpwoUK6Fr32U65Xx06prHPe1DWSelrxaSN/2mELTOE9w7ibXr
         1HVJtJvCY71fYcz5A4Cs+m2/LmPReuQIonfqj7eP/2+kMtNocSKFpvHRxaQF+dz6OvTj
         oRNAFrOijagHWAVgqNB47IqdkGzBNh8aNahOs=
Date: Mon, 5 Apr 2010 23:30:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.34-rc3
Message-ID: <20100406063051.GB1895@core.coreip.homeip.net>
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

to receive updates for the input subsystem.

Changelog:
---------

Chase Douglas (1):
      Input: ALPS - add signature for HP Pavilion dm3 laptops

Dmitry Torokhov (1):
      Input: sparse-keymap - implement safer freeing of the keymap

Dominik Brodowski (1):
      Input: i8042 - spelling fix

H Hartley Sweeten (1):
      Input: matrix_keypad - allow platform to disable key autorepeat

Henrik Rydberg (3):
      Input: bcm5974 - retract efi-broken suspend_resume
      Input: clarify the no-finger event in multitouch protocol
      Input: update the status of the Multitouch X driver project

Yong Wang (1):
      Input: sparse-keymap - free the right keymap on error


Diffstat:
--------

 Documentation/input/multi-touch-protocol.txt |   23 ++++++++---
 drivers/input/input.c                        |    9 ++++-
 drivers/input/keyboard/matrix_keypad.c       |    4 +-
 drivers/input/mouse/alps.c                   |    1 +
 drivers/input/mouse/bcm5974.c                |    1 -
 drivers/input/serio/i8042.c                  |    2 +-
 drivers/input/sparse-keymap.c                |   52 ++++++++++++++++---------
 include/linux/input/matrix_keypad.h          |    2 +
 8 files changed, 65 insertions(+), 29 deletions(-)

-- 
Dmitry

