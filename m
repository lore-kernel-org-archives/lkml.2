Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031366Ab2K3RVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:21:50 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42110 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478Ab2K3RVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:21:47 -0500
Date: Fri, 30 Nov 2012 09:21:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH RESEND] tty: don't dead lock while flushing workqueue
Message-ID: <20121130172143.GA6635@kroah.com>
References: <1353501542-14707-1-git-send-email-bigeasy@linutronix.de>
 <20121121140426.1860d093@pyramind.ukuu.org.uk>
 <20121127095357.GA3536@breakpoint.cc>
 <20121127172249.GB24592@kroah.com>
 <20121127180108.GA7376@linutronix.de>
 <20121130170938.GA7323@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130170938.GA7323@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 06:09:38PM +0100, Sebastian Andrzej Siewior wrote:
> On Tue, Nov 27, 2012 at 07:01:08PM +0100, Sebastian Andrzej Siewior wrote:
> > Since commit 89c8d91e31f2 ("tty: localise the lock") I see a dead lock
> > in one of my dummy_hcd + g_nokia test cases. The first run one was usually
> > okay, the second often resulted in a splat by lockdep and the third was
> > usually a dead lock.
> 
> Ping. Can you feed this to your tty tree? :)

It's really late in the release cycle, I would like to have this get
more testing in linux-next before I send it to Linus, so I was going to
wait until after 3.8-rc1 is out before doing it.

I'm doing the same thing for all tty/serial patches right now, so don't
feel like I'm picking on you :)

thanks,

greg k-h
