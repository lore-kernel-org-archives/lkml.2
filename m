Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935749Ab0GPHKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:10:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40164 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935739Ab0GPHKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QSzvUY45HI+IXFY9Y6aeFz93qlQvp7gX57euxxDVQI5jmMdMD821thc6QPFM9GpcOe
         FdqmmyRZth2me+Q6qyRRSruAJ2Dyie8dP6LmwxEXvc+R9N5/TGuG90YnYP3So7ikdqqf
         T69lLr0KAYiJsJQCC16d/+vCmNasWTkQu1dOk=
Date: Fri, 16 Jul 2010 00:10:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.35-rc5
Message-ID: <20100716071003.GC3712@core.coreip.homeip.net>
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

to receive updates for the input subsystem.

Changelog:
---------

Feng Tang (1):
      Input: i8042 - mark stubs in i8042.h "static inline"

Takashi Iwai (1):
      Input: synaptics - fix wrong dimensions check

Wan ZongShun (1):
      Input: w90p910_ts - fix call to setup_timer()


Diffstat:
--------

 drivers/input/mouse/synaptics.c        |    1 +
 drivers/input/touchscreen/w90p910_ts.c |    2 +-
 include/linux/i8042.h                  |   12 ++++++------
 3 files changed, 8 insertions(+), 7 deletions(-)

-- 
Dmitry

