Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1FPAlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 20:41:20 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54456 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab1FPAlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 20:41:17 -0400
X-Sasl-enc: C6spzTq4r3LM30epYAp5D9yhR0uyGr8HT3y61wcuk+AE 1308184876
Date: Wed, 15 Jun 2011 17:40:42 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 003 release
Message-ID: <20110616004042.GA9032@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 003 release of usbutils.

Just one fix, for those who like to compress the usb.ids file, it now
works properly :)

Thanks to Diego for the patch resolving this issue.

The package can be downladed from kernel.org:
	http://www.kernel.org/pub/linux/utils/usb/usbutils/

We've switched over to using git for development now, which makes things
much easier than the old cvs tree.  The tree can be found on both
kernel.org and github.com if you want to fork it and send us changes
easier:
	http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
	http://github.com/gregkh/usbutils/tree/master

thanks,

greg k-h

-----------

Diego Elio Pettenò (1):
      build-sys: properly enable support for zlib in lsusb

