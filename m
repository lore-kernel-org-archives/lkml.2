Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2BTUpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:45:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41207 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab2BTUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:45:43 -0500
Date: Mon, 20 Feb 2012 12:45:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [21/28] crypto: sha512 - Avoid stack bloat on i386
Message-ID: <20120220204509.GA16013@kroah.com>
References: <20120217021718.GA21573@kroah.com>
 <20120217022806.GA4980@gondor.apana.org.au>
 <20120217023742.GA21909@kroah.com>
 <20120216.215431.1415875817745523201.davem@davemloft.net>
 <20120217033054.GA22823@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217033054.GA22823@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 07:30:54PM -0800, Greg KH wrote:
> On Thu, Feb 16, 2012 at 09:54:31PM -0500, David Miller wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Date: Thu, 16 Feb 2012 18:37:42 -0800
> > 
> > > On Fri, Feb 17, 2012 at 01:28:06PM +1100, Herbert Xu wrote:
> > >> On Thu, Feb 16, 2012 at 06:17:18PM -0800, Greg KH wrote:
> > >> > On Thu, Feb 16, 2012 at 08:52:31PM -0500, David Miller wrote:
> > >> > > From: Greg KH <gregkh@linuxfoundation.org>
> > >> > > Date: Thu, 16 Feb 2012 16:55:55 -0800
> > >> > > 
> > >> > > > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > >> > > 
> > >> > > This causes a stack usage regression on sparc that Herbert
> > >> > > is in the middle of merging a fix for into Linus's tree.
> > >> > 
> > >> > Ick.  Any idea when that will hit Linus's tree?  If it's before next
> > >> > Monday, we are good, and I can queue it up here, if not, then I'll drop
> > >> > this and have to add it back later.
> > >> 
> > >> I've pushed it though it hasn't been pulled yet:
> > >> 
> > >> The commit ID is f2ea0f5f04c97b48c88edccba52b0682fbe45087.
> > > 
> > > Thanks, I'll watch out for it.
> > 
> > Greg, keep in mind that this stuff is in your 3.0-stable series too.
> 
> I just checked, and I also have this in the 2.6.32-stable tree, which I
> haven't sent out for review, but will next week.
> 
> Thanks for pointing it out.

Ok, that's now in Linus's tree, so I've queued it up for the 3.0 and 3.2
releases in a few hours.

greg k-h
