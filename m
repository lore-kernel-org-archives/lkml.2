Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1FTI4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:56:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45515 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1FTI4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TACaY3ryGEqaT0d5M7AUM0kGQTdHhX5K4qRcVyfhFFJaQXodmtAUZ6eh1QVD9Tgomt
         GbkJgD4dJIMFIES7DfVFFx2XT+qAMZuNQ3wAAhqQIwUmpgKS0w6X74bm22pGJF1PCyas
         gQPBbXC3tWkyym9vdoMOq8f29G6z6tnHghPRI=
Date: Mon, 20 Jun 2011 01:56:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.0-rc3
Message-ID: <20110620085621.GA26733@core.coreip.homeip.net>
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

to receive a couple of fixups for the input subsystem.

Changelog:
---------

Dmitry Torokhov (1):
      Input: evdev - try to wake up readers only if we have full packet

Hans Petter Selasky (1):
      Input: properly assign return value of clamp() macro.

Janusz Krzysztofik (1):
      Input: omap-keypad - add missing input_sync()

Magnus Damm (1):
      Input: sh_keysc - 8x8 MODE_6 fix


Diffstat:
--------

 drivers/input/evdev.c                |    3 ++-
 drivers/input/input.c                |    2 +-
 drivers/input/keyboard/omap-keypad.c |    1 +
 drivers/input/keyboard/sh_keysc.c    |    2 +-
 drivers/input/mousedev.c             |    4 ++--
 include/linux/input/sh_keysc.h       |    2 +-
 6 files changed, 8 insertions(+), 6 deletions(-)

-- 
Dmitry

