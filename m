Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab1LOTmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:42:02 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47261 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504Ab1LOTmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:42:00 -0500
X-Sasl-enc: 2+pO0qgKFpqMGdHFOuIQEA4uqhb28OUXo/9eQWWVcTFm 1323978119
Date: Thu, 15 Dec 2011 11:41:54 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] minor staging fixes for 3.2
Message-ID: <20111215194154.GB24990@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 3 tiny staging fixes for 3.2.

One is a new device id, and the other two are for the tidspbridge
driver, one fixing a build issue, and the other fixing a runtime issue
that is a regression from 3.1 that keeps the device from working at all.

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ staging-linus

All patches have been in the -next releases for a while now.

thanks,

greg k-h

--------------

 drivers/staging/rtl8712/usb_intf.c               |    1 +
 drivers/staging/tidspbridge/core/dsp-clock.c     |   15 ++++++++++++---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    4 ----
 3 files changed, 13 insertions(+), 7 deletions(-)

---------------

Larry Finger (1):
      staging: r8712u: Add new USB ID

Omar Ramirez Luna (2):
      staging: tidspbridge: include module.h by default
      staging: tidspbridge: request dmtimer clocks on init

