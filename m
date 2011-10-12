Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1JLUld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:41:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab1JLUlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:41:31 -0400
Date: Wed, 12 Oct 2011 14:33:37 -0600
From: Greg KH <gregkh@suse.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111012203337.GA14572@suse.de>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
 <20111012141724.GA17414@suse.de>
 <CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 06:59:01PM +0200, Markus Rechberger wrote:
> On Wed, Oct 12, 2011 at 4:17 PM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Oct 12, 2011 at 02:36:59PM +0200, Markus Rechberger wrote:
> >> We have 2 products which can perform better with increased Bulk transfers
> >
> > I don't believe you :)
> >
> > As stated before, this patch is not acceptable.  Please work to figure
> > out the real reason for your device problems here, this is not the
> > correct solution at all.
> >
> 
> OK no device support for linux then. Windows and MacOSX are fine.

That is your choice, not ours, as you are the one writing the closed
source code.  Without usbmon dumps, showing that the problem really is
in the kernel code, we can't do anything for you here.

Best of luck,

greg k-h
