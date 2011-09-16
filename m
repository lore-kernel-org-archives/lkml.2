Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab1IPSfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:35:32 -0400
Received: from 1wt.eu ([62.212.114.60]:33037 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab1IPSfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:35:31 -0400
Date: Fri, 16 Sep 2011 20:35:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@suse.de>
Cc: Josh Boyer <jwboyer@redhat.com>, andi@firstfloor.org,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: stable patch queues and submission
Message-ID: <20110916183516.GA4121@1wt.eu>
References: <20110916181307.GW10700@zod.bos.redhat.com> <20110916182350.GA7315@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916182350.GA7315@suse.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 08:23:50PM +0200, Greg KH wrote:
> > Hi All,
> > 
> > With kernel.org being down, the stable@kernel.org list is no longer
> > working.  This leaves me wondering if we should send patches directly to
> > the various stable tree maintainers with [stable] in the prefix and
> > linux-kernel CC'd, or if the stable queues are even being maintained
> > during the outage.
> 
> No, please do not, unless you need something "special", and even then,
> please cc: lkml and the developers so it's not lost.
> 
> > Does anyone have a preference or suggestion on how to continue stable
> > releases until the list comes back?  (I'm assuming 'wait' isn't really a
> > best all around option.)
> 
> Wait and continue to add the marking to your patches, my scripts are
> still running and pulling the patches out and they are going into the
> stable queue just fine.  The queue just isn't public at the moment due
> to kernel.org being out.

I was thinking about an alternative if that can help. If the mails are
sent to our addresses followed by "+stable", they're easy to filter out
to another mailbox (eg: "willy+stable@1wt.eu").

But there are a number of other reviewers on stable@k.o who provide a
lot of value with their reviews, and not having them check the patches
could easily lead to some nasty patches leaking into stable.

Regards,
Willy

