Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab1JKEJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 00:09:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1JKEJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 00:09:31 -0400
Date: Mon, 10 Oct 2011 20:59:24 -0700
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: hpa@zytor.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: stable mailing list?
Message-ID: <20111011035924.GC29668@suse.de>
References: <1318290984.7904.127.camel@gandalf.stny.rr.com>
 <20111011000759.GA28709@suse.de>
 <4E9389A5.1080300@zytor.com>
 <20111010.230500.1524387763129785129.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010.230500.1524387763129785129.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 11:05:00PM -0400, David Miller wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Mon, 10 Oct 2011 17:11:17 -0700
> 
> > On 10/10/2011 05:07 PM, Greg KH wrote:
> >> On Mon, Oct 10, 2011 at 07:56:23PM -0400, Steven Rostedt wrote:
> >>> I received a bounce from stable@kernel.org. What should we be Ccing to?
> >> 
> >> You should be marking your patch with a:
> >> 	Cc: stable <stable@kernel.org>
> >> 
> >> and when it hits Linus's tree, I properly pick it up.  Right now, the
> >> mailing list isn't working, and I am considering just having it point to
> >> a vger list as that makes more sense.  I'll ask Dave to set this up when
> >> I land as I'm traveling at the moment...
> >> 
> > 
> > Hi Dave,
> > 
> > Can you set up <stable@vger.kernel.org> and we'll point
> > <stable@kernel.org> to it?
> 
> Done.

Wonderful, thanks for doing this.

greg k-h
