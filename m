Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1F0Vrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:47:48 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47061 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754912Ab1F0Vqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:46:39 -0400
X-Sasl-enc: kRQ8veZoR2GTWct5upQ77+PJu1R1RPnEKSuPXCPFpphH 1309211198
Date: Mon, 27 Jun 2011 14:45:47 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: brudley@broadcom.com, henryp@broadcom.com, rvossen@broadcom.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 related)
Message-ID: <20110627214547.GA10889@kroah.com>
References: <20110609184127.GA2760@kroah.com>
 <20110609192243.GA3980@kroah.com>
 <20110610160548.529797c7.sfr@canb.auug.org.au>
 <20110610160938.cd01c408.sfr@canb.auug.org.au>
 <20110610223423.GB15868@kroah.com>
 <20110615142155.bd538b73.sfr@canb.auug.org.au>
 <20110616191448.GA10255@kroah.com>
 <20110623103503.cd9e7e70.sfr@canb.auug.org.au>
 <20110623215115.GB10969@kroah.com>
 <20110624100005.f9f59ddf.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110624100005.f9f59ddf.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 10:00:05AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Thu, 23 Jun 2011 14:51:15 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > Sorry, I'm away from home, with a very spotty internet connection, on
> > vacation, so it's hard to get this done at the moment.  I'll get to it
> > on the 27th when I return.
> 
> I can understand vacation as well :-)
> 
> Thanks.  I will use Ralf's (arch restricting) patch until you come up
> with something better.

That's good, but it doesn't fix the root problem here.  I've now fixed
this up in the staging-linus branch.

You shouldn't have any more build breakages in the drivers/staging/*
tree now as I am pretty sure I've fixed all reported issues.  If not,
please let me know.

thanks,

greg k-h
