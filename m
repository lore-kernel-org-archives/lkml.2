Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1CQVqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:46:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:49817 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab1CQVqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:46:10 -0400
Date: Thu, 17 Mar 2011 14:45:37 -0700
From: Greg KH <gregkh@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 00/12] Staging: hv: Cleanup vmbus driver - Phase II
Message-ID: <20110317214537.GA28608@suse.de>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <20110315220454.GC30390@suse.de>
 <30255.1300397967@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30255.1300397967@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 05:39:27PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 15 Mar 2011 15:04:54 PDT, Greg KH said:
> 
> > Thanks for the patches, but as the .39 merge window is closed, I'll be
> > holding on to these until after .39-rc1 is out before I can do anything
> > with them.
> 
> Is that Linus's merge window, or your window to freeze a for-linus tree?

My window.

Linus's merge window is for the subsystem maintainers.  Everything that
is to be sent during Linus's merge window had to be in the linux-next
tree for a bit of time before the merge window opens.

It's been this way for a number of years now, nothing new happening
here...

I also posted the "my tree is now closed for .39 stuff" message to the
devel mailing list, so there shouldn't have been any questions about
this.

thanks,

greg k-h
