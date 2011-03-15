Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1COWa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:30:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab1COWa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:30:58 -0400
Date: Tue, 15 Mar 2011 15:30:32 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/12] Staging: hv: Cleanup vmbus driver - Phase II
Message-ID: <20110315223032.GA9046@suse.de>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <20110315220454.GC30390@suse.de>
 <6E21E5352C11B742B20C142EB499E048019A87@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048019A87@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 10:24:41PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Tuesday, March 15, 2011 6:05 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org
> > Subject: Re: [PATCH 00/12] Staging: hv: Cleanup vmbus driver - Phase II
> > 
> > On Tue, Mar 15, 2011 at 03:02:07PM -0700, K. Y. Srinivasan wrote:
> > > This patch-set fixes the following issues in the vmbus driver (vmbus_drv.c):
> > 
> > <snip>
> > 
> > Thanks for the patches, but as the .39 merge window is closed, I'll be
> > holding on to these until after .39-rc1 is out before I can do anything
> > with them.
> > 
> > So don't be surprised if I don't respond to them for a few weeks.  Don't
> > worry, they aren't lost. :)
> 
> If possible, I would love to get your feedback even if you cannot check 
> in these patches. Also, if you can give me feedback as to what else
> would need to be fixed to exit staging  as far as the vmbus driver is 
> concerned, I can work on those over the next couple of weeks
> until the tree opens up.

As I'm going to be very busy with the merge window issues, coupled with
spring break and the LF Collab summit, I doubt I'll be able to do this,
sorry.  Give me a few weeks please.

> If it is ok with you we will send the DPRINT cleanup patches in the
> next couple of days.

That's fine, they can sit in the same "to-apply" mbox next to these :)

greg k-h
