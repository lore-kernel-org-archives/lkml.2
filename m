Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1BOQlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:41:55 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36536 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab1BOQlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:41:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pXyG4zVWToNImyqmX4yloBMUqPlmXKxMUJ15lR1cm2tNyLBehL7XVs9+AB/ZQIqQX/
         bQ4o9BKkLRNRQkcKVyY2sGd8MsrWdvcE1nw2avcM3bmdaIWLPwWYaaGO5BKCA9ntykY/
         zNXlIaM0+49yu0H1l8ZxkoP0pN9/1ncXkoDPI=
Date: Tue, 15 Feb 2011 08:41:45 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.38-rc4
Message-ID: <20110215164145.GA32308@core.coreip.homeip.net>
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

to receive updates for the input subsystem. Nothing exciting, just small
fixups to the drivers.

Changelog:
---------

Alexander Stein (1):
      Input: rotary_encoder - use proper irqflags

Alexander Strakh (1):
      Input: wacom - fix error path in wacom_probe()

Dmitry Torokhov (3):
      Input: sysrq - rework re-inject logic
      Revert "Input: do not pass injected events back to the originating handler"
      Input: ads7846 - check proper condition when freeing gpio

Duncan Laurie (1):
      Input: serio - clear pending rescans after sysfs driver rebind

Ping Cheng (1):
      Input: wacom_w8001 - report resolution to userland

Trilok Soni (1):
      Input: matrix_keypad - increase the limit of rows and columns


Diffstat:
--------

 drivers/input/input.c                   |   37 +++++++++---------------------
 drivers/input/misc/rotary_encoder.c     |    4 +-
 drivers/input/serio/serio.c             |   11 +++++---
 drivers/input/tablet/wacom_sys.c        |    2 +-
 drivers/input/touchscreen/ads7846.c     |   38 ++++++++++++++++++-------------
 drivers/input/touchscreen/wacom_w8001.c |   13 +++++++++-
 drivers/tty/sysrq.c                     |   17 +++++++++++++-
 include/linux/input/matrix_keypad.h     |    4 +-
 8 files changed, 72 insertions(+), 54 deletions(-)

-- 
Dmitry
