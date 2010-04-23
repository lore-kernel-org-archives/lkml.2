Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab0DWQIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:08:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757943Ab0DWQIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:08:16 -0400
Date: Fri, 23 Apr 2010 09:06:57 -0700
From: Greg KH <gregkh@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, NeilBrown <neilb@suse.de>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [166/197] md/raid5: allow for more than 2^31
 chunks.
Message-ID: <20100423160657.GD8048@suse.de>
References: <20100422191857.GA13268@kroah.com>
 <20100422190922.238365037@kvm.kroah.org>
 <20100422203338.617debf9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422203338.617debf9@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 08:33:37PM -0400, Chuck Ebbert wrote:
> On Thu, 22 Apr 2010 12:10:17 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > 2.6.32-stable review patch.  If anyone has any objections, please let
> > us know.
> > 
> > ------------------
> > 
> > From: NeilBrown <neilb@suse.de>
> > 
> > commit 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d upstream.
> > 
> > With many large drives and small chunk sizes it is possible
> > to create a RAID5 with more than 2^31 chunks.  Make sure this
> > works.
> 
> Causes build failure on i686:
> ERROR: "__umoddi3" [drivers/md/raid456.ko] undefined!
> 
> http://lkml.org/lkml/2010/4/22/50

Ok, for now I've removed this patch from the .32 and .33 series, and
will queue it up for the next round, once the build fix is in Linus's
tree.

thanks,

greg k-h
