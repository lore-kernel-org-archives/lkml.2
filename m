Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0LFP6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:58:24 -0500
Received: from kroah.org ([198.145.64.141]:60922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab0LFP6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:58:22 -0500
Date: Mon, 6 Dec 2010 07:56:25 -0800
From: Greg KH <greg@kroah.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: whci-hcd: fix compiler warning
Message-ID: <20101206155625.GC23214@kroah.com>
References: <1291177721-17598-1-git-send-email-namhyung@gmail.com>
 <20101201161039.GB29318@suse.de>
 <1291222151.1684.46.camel@leonhard>
 <20101201173604.GA30708@suse.de>
 <1291640730.1696.29.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291640730.1696.29.camel@leonhard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 10:05:30PM +0900, Namhyung Kim wrote:
> 2010-12-01 (수), 09:36 -0800, Greg KH:
> > On Thu, Dec 02, 2010 at 01:49:11AM +0900, Namhyung Kim wrote:
> > > 2010-12-01 (수), 08:10 -0800, Greg KH:
> > > > On Wed, Dec 01, 2010 at 01:28:41PM +0900, Namhyung Kim wrote:
> > > > > Annotate whci_hcd_id_table as '__used' to fix following warning:
> > > > > 
> > > > >   CC      drivers/usb/host/whci/hcd.o
> > > > > drivers/usb/host/whci/hcd.c:359: warning: ‘whci_hcd_id_table’ defined but not used
> > > > 
> > > > Are you seeing this warning when you build the module into the kernel,
> > > > or as a module?
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > I saw it during allyesconfig build but not on allmodconfig.
> > > Maybe we can wrap it up in #ifdef CONFIG_MODULES ?
> > 
> > No, don't do that, your __used is the correct thing here, I just wanted
> > to make sure why you were seeing this warning.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi, Greg
> 
> It seems this one is not applied in your tree yet. Do you need a resend?

Yes please, I must have missed it, thinking it was part of your other
series.  Sorry.

greg k-h
