Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2K0RV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:21:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53229 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab2K0RVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:21:25 -0500
Date: Tue, 27 Nov 2012 09:22:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] tty: don't dead while flushing workqueue
Message-ID: <20121127172249.GB24592@kroah.com>
References: <1353501542-14707-1-git-send-email-bigeasy@linutronix.de>
 <20121121140426.1860d093@pyramind.ukuu.org.uk>
 <20121127095357.GA3536@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127095357.GA3536@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 10:53:57AM +0100, Sebastian Andrzej Siewior wrote:
> On Wed, Nov 21, 2012 at 02:04:26PM +0000, Alan Cox wrote:
> > > I don't see any problems in my testcase.
> > 
> > This looks fine to me as by the time we call tty_ldisc_release we have
> > already set TTY_CLOSING on both sides.
> 
> Greg, can you push this into v3.7? This regression has been introduced in
> v3.7-rc1. If you don't consider it as this important since I'm only one
> complaining, could you please add a stable tag once you apply it unless you
> want me resend it with a stable tag.

I don't see this patch anywhere in my queue, or in the tty-next tree, so
someone is going to have to resend it please.

And yes, it's a bit too late for 3.7, but I don't have an issue with
merging it for 3.8-rc1 and tagging it for 3.7-stable.

thanks,

greg k-h
