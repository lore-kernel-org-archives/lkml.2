Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab1GFDsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:48:42 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37806 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756055Ab1GFDsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:48:40 -0400
X-Sasl-enc: W8O08Vqa+CbVUatRkV2ominU+3Vyu/uHUIrb3x3YUlLA 1309924119
Date: Tue, 5 Jul 2011 20:48:35 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.0
Message-ID: <20110706034835.GA4695@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's 2 fixes for your 3.0 tree.

The device removal fix has been reported a lot lately, and this should
resolve the obvious problem (there might still be an issue in the scsi
layer that the scsi developers are still arguing over.)
The build fix resolves a regression from 2.6.39 that was introduced in
3.0-rc1.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/message.c        |    2 ++
 drivers/usb/gadget/fsl_udc_core.c |   36 ++++++++++++++++++++++++------------
 2 files changed, 26 insertions(+), 12 deletions(-)

---------------

Alan Stern (1):
      USB: fix regression occurring during device removal

Anatolij Gustschin (1):
      USB: fsl_udc_core: fix build breakage when building for ARM arch

