Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1FILsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab1FILsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:48:02 -0400
Date: Thu, 9 Jun 2011 07:47:45 -0400
From: Don Zickus <dzickus@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/4] watchdog: fix rounding issues in get_sample_period()
Message-ID: <20110609114745.GQ8162@redhat.com>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
 <20110518135302.GM29881@redhat.com>
 <20110519162631.GJ11023@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519162631.GJ11023@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 09:26:31AM -0700, Mandeep Singh Baines wrote:
> Don Zickus (dzickus@redhat.com) wrote:
> > On Mon, May 16, 2011 at 04:34:58PM -0700, Mandeep Singh Baines wrote:
> > > In get_sample_period(), softlockup_thresh is integer divided by 5 before
> > > the multiplication by NSEC_PER_SEC. This results in softlockup_thresh
> > > being rounded down to the nearest integer multiple of 5.
> > > 
> > > For example, a softlockup_thresh of 4 rounds down to 0.
> > 
> > Mandeep,
> > 
> > Thanks for the patches.  Unfortunately, I am taking some time off so I'll
> > shephard these patches when I get back.  For the most part they look fine,
> > aside from Ingo's comments.
> > 
> 
> No problem. Enjoy your time off:)
> 
> Ingo, since Don is out, would you mind acking the patches (assuming you're
> happy). It simplifies pushing these patches into our local ChromiumOS tree
> if I have an upstream ack.

Hi Mandeep,

It looks like Ingo took most of your patches.  Is there any outstanding
ones that didn't make it that you see?

Cheers,
Don
