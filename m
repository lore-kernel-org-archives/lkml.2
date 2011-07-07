Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1GGUuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 16:50:09 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56181 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798Ab1GGUuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 16:50:08 -0400
X-Sasl-enc: CdkVkMc+vDodPQeT+w958xVftBUvZ53yUxiwnFSoHp07 1310071807
Date: Thu, 7 Jul 2011 13:49:37 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] another USB fix for 3.0
Message-ID: <20110707204937.GA13006@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more USB regression fix for 3.0.

This one is a continuation of the last one you accepted, which fixed the
problem for some people, but not all.  This one fixes it for everyone.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

thanks,

greg k-h

------------

 drivers/usb/core/message.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

---------------

Alan Stern (1):
      USB: additional regression fix for device removal

