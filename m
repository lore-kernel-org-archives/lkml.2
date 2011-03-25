Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1CYH2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:28:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64284 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1CYH2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=w1ZQM7x5kjQjFntNooH9LsQT8pBUIF9k5Co88rWG4i7f8fPXuyvXPESirFUsRkqJeK
         ikydajpG6FCGDlII04/s4/1z56T5nfzd33mcME4LVe46iseTOIgR1yw5ppKxlF4y2jn8
         RQdCxH5XteTc4TwnNn3Gb0k131W6m68VT5nro=
Date: Fri, 25 Mar 2011 00:27:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.39-rc0
Message-ID: <20110325072759.GA2590@core.coreip.homeip.net>
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

to receive a few updates to recently merged tsc2005 driver.

Changelog:
---------

Aaro Koskinen (2):
      Input: tsc2005 - use relative jiffies to schedule the watchdog
      Input: tsc2005 - fix locking issue

Geert Uytterhoeven (1):
      Input: tsc2005 - driver should depend on GENERIC_HARDIRQS


Diffstat:
--------

 drivers/input/touchscreen/Kconfig   |    2 +-
 drivers/input/touchscreen/tsc2005.c |   18 +++++++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

-- 
Dmitry

