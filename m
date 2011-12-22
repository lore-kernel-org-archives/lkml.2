Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1LVUsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:48:46 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51605 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008Ab1LVUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:48:43 -0500
X-Sasl-enc: RrYxWZvlTjYFr8vlwcQcCTaPkQ5H1elhVq6iSaHvxbHL 1324586922
Date: Thu, 22 Dec 2011 12:48:39 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] final USB fixes for 3.2
Message-ID: <20111222204839.GA15290@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 4 tiny USB fixes for the 3.2 tree.  After this, I don't
anticipate any more patches for 3.2 that I know of at the moment, which
is good, as I'll be away from a computer all next week.

All pretty minor, full details are in the shortlog below.

Please pull from:
	git.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb.git/ usb-linus

All have been in the last -next release.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/dwc3/core.c         |    2 +-
 drivers/usb/gadget/epautoconf.c |    3 ---
 drivers/usb/host/isp1760-if.c   |    8 ++++----
 drivers/usb/musb/musb_host.c    |    4 ++++
 4 files changed, 9 insertions(+), 8 deletions(-)

---------------

Ajay Kumar Gupta (1):
      usb: musb: fix reset issue with full speed device

David Miller (1):
      USB: Fix usb/isp1760 build on sparc

Felipe Balbi (2):
      usb: dwc3: core: fix cached revision on our structure
      usb: gadget: epautoconf: do not change number of streams

