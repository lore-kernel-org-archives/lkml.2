Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1HZTM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 15:12:29 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59246 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705Ab1HZTMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 15:12:25 -0400
X-Sasl-enc: p+4Sinqj16lTVUiKwiZKT0mTHZLtOll0nC3bDDhs2d7i 1314385944
Date: Fri, 26 Aug 2011 12:11:38 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] more STAGING fixes for 3.1
Message-ID: <20110826191138.GB5557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of minor staging driver fixes for your 3.1 tree.

Full details are below, nothing really major, but lots of build fixes
for stuff people have reported.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-linus

All patches have been in the -next releases for a while now.

These patches will be sent to the linux driver project list for all to
see.

thanks,

greg k-h

--------------

 drivers/staging/brcm80211/brcmsmac/otp.c     |    1 +
 drivers/staging/brcm80211/brcmsmac/types.h   |    1 +
 drivers/staging/octeon/ethernet-rgmii.c      |    1 +
 drivers/staging/octeon/ethernet-spi.c        |    1 +
 drivers/staging/tidspbridge/core/dsp-clock.c |    1 -
 drivers/staging/zcache/tmem.c                |    2 +-
 drivers/staging/zcache/zcache-main.c         |    8 ++++----
 7 files changed, 9 insertions(+), 6 deletions(-)

---------------

Arend Van Spriel (1):
      staging: brcm80211: fix compile error on non-x86 archs since 3.0 kernel

Dan Carpenter (1):
      Staging: zcache: signedness bug in tmem_get()

David Daney (1):
      staging: octeon-ethernet: Add missing #includes.

Omar Ramirez Luna (1):
      staging: tidspbridge: fix compilation on dsp clock functions

Pieter-Paul Giesberts (1):
      staging: brcm80211: SPARC build error fix

Seth Jennings (1):
      staging: zcache: fix crash on high memory swap

