Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2JPUr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:47:28 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55572 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304Ab2JPUr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:47:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjYoAGLHfVB5LJyt/2dsb2JhbABFuiWEZAKBAIEJgiABAQU6HCMQCAMOCi4UJQMhE4gDuyYUizuBZ4RWA5VqkDODAQ
Date: Wed, 17 Oct 2012 07:46:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: William Dauchy <wdauchy@gmail.com>
Cc: stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Mark Tinguely <tinguely@sgi.com>, Ben Myers <bpm@sgi.com>
Subject: Re: xfs: fix buffer lookup race on allocation failure
Message-ID: <20121016204635.GG2864@dastard>
References: <CAJ75kXZsBfhydOSF1Tjpp_OOndWs=jbC_YvrZ9Fw22+Q4rp1yw@mail.gmail.com>
 <20121015232147.GG2739@dastard>
 <CAJ75kXa0GeW1i5EgHgpuQEiTN0_bpFKpeZbCJqBkqLtq5hNRSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXa0GeW1i5EgHgpuQEiTN0_bpFKpeZbCJqBkqLtq5hNRSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 11:27:48AM +0200, William Dauchy wrote:
> Hello Dave,
> 
> Thanks for your reply.
> 
> On Tue, Oct 16, 2012 at 1:21 AM, Dave Chinner <david@fromorbit.com> wrote:
> > You're running a CONFIG_XFS_DEBUG kernel. If you can reproduce the
> > problem with CONFIG_XFS_DEBUG, then it probably should be
> > backported.
> 
> Yes indeed.

Sorry, I had a typo in the above - I meant:

If you can reproduce the problem *without* CONFIG_XFS_DEBUG, then it
probably should be backported.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
