Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab1KVBBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:01:39 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45079 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757573Ab1KVA7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:59:37 -0500
X-Sasl-enc: BAnenOHmgKeik2KTOJrpBFlCSxFMW/zPne/9ZfvV+TWZ 1321923576
Date: Mon, 21 Nov 2011 16:59:07 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] staging fixes for 3.2
Message-ID: <20111122005907.GC25420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few build fixes for the staging tree that need to get into
the final 3.2 release as people keep hitting them.

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ staging-linus

All patches have been in the -next releases for a while now.

thanks,

greg k-h

--------------

 drivers/staging/et131x/Kconfig  |    3 ++-
 drivers/staging/et131x/et131x.c |   12 ++++++------
 drivers/staging/slicoss/Kconfig |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

---------------

Mark Einon (1):
      linux-next: et131x: Fix build error when CONFIG_PM_SLEEP not enabled

Randy Dunlap (3):
      staging: slicoss depends on NET
      staging: et131x depends on NET
      staging: fix more ET131X build errors

