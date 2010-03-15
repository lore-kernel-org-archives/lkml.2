Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965816Ab0COXpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:45:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:38517 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab0COXpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:45:34 -0400
Date: Mon, 15 Mar 2010 16:44:24 -0700
From: Greg KH <gregkh@suse.de>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware()
 messages
Message-ID: <20100315234424.GA4008@suse.de>
References: <201002272143.22156.rjw@sisk.pl>
 <3f9a31f41002281213y2d65ae37xf9934a0775d8d9ee@mail.gmail.com>
 <20100315201659.GA6757@kroah.com>
 <201003152227.11295.rjw@sisk.pl>
 <3f9a31f41003151634k5f8521c0l99179bcf02d9e551@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f9a31f41003151634k5f8521c0l99179bcf02d9e551@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 05:04:09AM +0530, Jaswinder Singh Rajput wrote:
> Hello Rafael,
> 
> On Tue, Mar 16, 2010 at 2:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > I still think it's a good idea.  The information about what firmware is being
> > used doesn't seem to be very useful for anything but debugging, so I think
> > KERN_DEBUG is actually the right level for these messages.
> >
> 
> Can we use printk_once()

No, I'd rather use dev_dbg() that way we can dynamically turn it on and
off as needed.  I took Rafael's original patch.

Funny thing is, someone else also sent the same patch, so there must be
others wanting this change :)

thanks,

greg k-h
