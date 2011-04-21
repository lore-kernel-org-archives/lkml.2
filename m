Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1DUOWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:22:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1DUOWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:22:14 -0400
Date: Thu, 21 Apr 2011 10:22:07 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Don't forget to clear
 cpuc->active_mask on overflow
Message-ID: <20110421142207.GD31724@redhat.com>
References: <4DAEF821.4050103@openvz.org>
 <20110421125345.GC31724@redhat.com>
 <20110421131748.GB1642@elte.hu>
 <20110421135742.GZ20887@redhat.com>
 <4DB03872.2020504@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB03872.2020504@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 06:00:18PM +0400, Cyrill Gorcunov wrote:
> On 04/21/2011 05:57 PM, Don Zickus wrote:
> ...
> > 
> > Cyril is that something you can do because I think all of these patches
> > revolve around P4 fixes?  Though I don't know what are all the patches.  I
> > know I had one and this patch.  Is there another on Cyril?
> > 
> > Cheers,
> > Don
> 
> Don, I've two patches for P4 and one yours which is a fast fix for unknown-nmi.
> So I could gather all three patches and send them to Ingo. And you'll see them
> and review again as well. Deal? :)

You can add my acked-by and/or review-by tags to the patches.  But yeah I
can review them again.

Cheers,
Don
