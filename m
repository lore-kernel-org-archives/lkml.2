Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1DUN5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:57:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab1DUN5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:57:49 -0400
Date: Thu, 21 Apr 2011 09:57:42 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Lin Ming <ming.m.lin@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Don't forget to clear
 cpuc->active_mask on overflow
Message-ID: <20110421135742.GZ20887@redhat.com>
References: <4DAEF821.4050103@openvz.org>
 <20110421125345.GC31724@redhat.com>
 <20110421131748.GB1642@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421131748.GB1642@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 03:17:48PM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > On Wed, Apr 20, 2011 at 07:13:37PM +0400, Cyrill Gorcunov wrote:
> > > It's not enough to simply disable event on overflow the cpuc->active_mask
> > > should be cleared as well otherwise counter may stall in "active" even
> > > in real being already disabled (which potentially may lead to the situation
> > > that user may not use this counter further).
> > 
> > I also noticed this patch fixed some unknown NMIs on a P4 when I stressed
> > the box
> > 
> > Acked-by: Don Zickus <dzickus@redhat.com>
> 
> Ok. Mind one of you resending all pending patches in this area, with all 
> Acked-by's and Tested-by's in place?

Cyril is that something you can do because I think all of these patches
revolve around P4 fixes?  Though I don't know what are all the patches.  I
know I had one and this patch.  Is there another on Cyril?

Cheers,
Don
