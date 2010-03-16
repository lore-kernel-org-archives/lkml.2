Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937222Ab0CPAPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 20:15:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab0CPAPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 20:15:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware() messages
Date: Tue, 16 Mar 2010 01:17:59 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
References: <201002272143.22156.rjw@sisk.pl> <3f9a31f41003151634k5f8521c0l99179bcf02d9e551@mail.gmail.com> <20100315234424.GA4008@suse.de>
In-Reply-To: <20100315234424.GA4008@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003160117.59116.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 March 2010, Greg KH wrote:
> On Tue, Mar 16, 2010 at 05:04:09AM +0530, Jaswinder Singh Rajput wrote:
> > Hello Rafael,
> > 
> > On Tue, Mar 16, 2010 at 2:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >
> > > I still think it's a good idea.  The information about what firmware is being
> > > used doesn't seem to be very useful for anything but debugging, so I think
> > > KERN_DEBUG is actually the right level for these messages.
> > >
> > 
> > Can we use printk_once()
> 
> No, I'd rather use dev_dbg() that way we can dynamically turn it on and
> off as needed.  I took Rafael's original patch.

OK, thanks!

> Funny thing is, someone else also sent the same patch, so there must be
> others wanting this change :)

I know SGI wants it at least.

Rafael
