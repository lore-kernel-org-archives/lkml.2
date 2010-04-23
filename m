Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0DWD3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 23:29:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:40468 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab0DWD3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 23:29:47 -0400
Date: Thu, 22 Apr 2010 20:11:28 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, NeilBrown <neilb@suse.de>, akpm@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [166/197] md/raid5: allow for more than 2^31
	chunks.
Message-ID: <20100423031128.GB1637@suse.de>
References: <20100422191857.GA13268@kroah.com> <20100422190922.238365037@kvm.kroah.org> <20100422203338.617debf9@redhat.com> <alpine.LFD.2.00.1004221758270.26046@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004221758270.26046@i5.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 05:58:47PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 22 Apr 2010, Chuck Ebbert wrote:
> 
> > On Thu, 22 Apr 2010 12:10:17 -0700
> > Greg KH <gregkh@suse.de> wrote:
> > 
> > > 2.6.32-stable review patch.  If anyone has any objections, please let
> > > us know.
> > > 
> > > ------------------
> > > 
> > > From: NeilBrown <neilb@suse.de>
> > > 
> > > commit 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d upstream.
> > > 
> > > With many large drives and small chunk sizes it is possible
> > > to create a RAID5 with more than 2^31 chunks.  Make sure this
> > > works.
> > 
> > Causes build failure on i686:
> > ERROR: "__umoddi3" [drivers/md/raid456.ko] undefined!
> > 
> > http://lkml.org/lkml/2010/4/22/50
> 
> Yeah, that one is definitely not stable material as-is.

Neil did post a patch to fix it, hopefully it gets into your tree soon.

thanks,

greg k-h
