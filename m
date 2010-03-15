Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937184Ab0COXhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:37:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38315 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933017Ab0COXhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:37:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware() messages
Date: Tue, 16 Mar 2010 00:40:01 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
References: <201002272143.22156.rjw@sisk.pl> <201003152227.11295.rjw@sisk.pl> <3f9a31f41003151634k5f8521c0l99179bcf02d9e551@mail.gmail.com>
In-Reply-To: <3f9a31f41003151634k5f8521c0l99179bcf02d9e551@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003160040.01774.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 March 2010, Jaswinder Singh Rajput wrote:
> Hello Rafael,
> 
> On Tue, Mar 16, 2010 at 2:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > I still think it's a good idea.  The information about what firmware is being
> > used doesn't seem to be very useful for anything but debugging, so I think
> > KERN_DEBUG is actually the right level for these messages.
> >
> 
> Can we use printk_once()

Yes, I guess so.

OK, I'll rework the patch.

Thanks,
Rafael
