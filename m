Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab2JVQVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:21:44 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45561 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702Ab2JVQVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:21:42 -0400
X-Sasl-enc: YfQRbBQQDvNaj6qOpd3D4mNY9Wu7GD07nVjk1QajmZaQ 1350922901
Date: Mon, 22 Oct 2012 09:21:40 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbview 2.0 release
Message-ID: <20121022162140.GA10021@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 2 1/2 years, I figure it's about time for a new release of
usbview, as some people still use it, and with recent kernels making
usbfs go away, there have been some reports of problems.

Big changes from the 1.1 release in 2009 is:
	- gtk3 support
	- use debugfs instead of obsolete usbfs files.

Both changes came from Hans de Goede, many thanks for the patches.

The package can be downladed at:
	http://www.kroah.com/linux/usb/usbview-2.0.tar.gz
and the git tree can be found at:
	http://github.com/gregkh/usbview

thanks,

greg k-h
