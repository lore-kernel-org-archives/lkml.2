Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031443Ab2K3SMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:12:08 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34797 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031428Ab2K3SMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:12:03 -0500
Date: Fri, 30 Nov 2012 19:11:59 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH RESEND] tty: don't dead lock while flushing workqueue
Message-ID: <20121130181159.GA7468@breakpoint.cc>
References: <1353501542-14707-1-git-send-email-bigeasy@linutronix.de>
 <20121121140426.1860d093@pyramind.ukuu.org.uk>
 <20121127095357.GA3536@breakpoint.cc>
 <20121127172249.GB24592@kroah.com>
 <20121127180108.GA7376@linutronix.de>
 <20121130170938.GA7323@breakpoint.cc>
 <20121130172143.GA6635@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130172143.GA6635@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 09:21:43AM -0800, Greg Kroah-Hartman wrote:
> > Ping. Can you feed this to your tty tree? :)
> 
> It's really late in the release cycle, I would like to have this get
> more testing in linux-next before I send it to Linus, so I was going to
> wait until after 3.8-rc1 is out before doing it.

I assumed that you apply this to your tty-next tree so it appears in
linux-next. So now I wait until -rc2 is out and ping again if nothing
happens :)

> I'm doing the same thing for all tty/serial patches right now, so don't
> feel like I'm picking on you :)

Next time I look for a bug that annoys everyone :)
Nah. I saw some movement in tty-next so I though I ping you. But staging
stuff is probably a different category.

> 
> thanks,
> 
> greg k-h

Sebastian
