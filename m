Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619Ab0LUEma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:42:30 -0500
Received: from kroah.org ([198.145.64.141]:44633 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933557Ab0LUEmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:42:10 -0500
Date: Mon, 20 Dec 2010 20:42:05 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [GIT PATCH] TTY/serial fixes for .37-rc6
Message-ID: <20101221044205.GB11750@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two tty fixes for your .37-rc6 tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/ tty-linus

Both of these have been in the -next and -mm releases for a while.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/tty/n_gsm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

---------------

Ken Mills (2):
      n_gsm: Fix message length handling when building header
      n_gsm: gsm_data_alloc buffer allocation could fail and it is not being checked

