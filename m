Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab2DXT1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:27:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48525 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015Ab2DXT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:27:14 -0400
Date: Tue, 24 Apr 2012 21:27:09 +0200
From: =?iso-8859-1?Q?St=E9phane?= Pajot <pajot.stephane@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: rdunlap@xenotime.net, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix trailing whitespace and quoted
 string split across lines in ni_labpc.c
Message-ID: <20120424192709.GA4717@stef-pc>
References: <1335286210-3150-1-git-send-email-pajot.stephane@gmail.com>
 <20120424184642.GA20004@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120424184642.GA20004@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 11:46:42AM -0700, Greg KH wrote:
> On Tue, Apr 24, 2012 at 06:50:10PM +0200, Stéphane Pajot wrote:
> > This is a patch to the ni_labpc.c file that fixes up trailing whitespace error and quoted string split across lines warning
> > found by the checkpatch.pl tool
> 
> Please only fix one type of thing per patch, so this should be a two
> patch series at the least.
Ok for that.
> 
> But...
> 
> > @@ -738,7 +738,7 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
> >  		irq = it->options[1];
> >  		dma_chan = it->options[2];
> >  #else
> > -		printk(KERN_ERR " this driver has not been built with ISA DMA "
> > +		printk(KERN_ERR " this driver has not been built with ISA DMA\n"
> >  								"support.\n");
> 
> What?  Why did you do this?  Do you understand what you just did to the
> message printed out?

... It was just to patch this "quoted string split across lines
warning", i saw this solution on the web. Now i think i understand that
i cannot modify AT ALL a printk(KERN_ERR* even if it's just with a \n ?

Stef
> 
> greg k-h


