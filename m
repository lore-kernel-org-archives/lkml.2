Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab0FSM3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 08:29:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60157 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab0FSM3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 08:29:19 -0400
Date: Sat, 19 Jun 2010 14:29:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, hugh.dickins@tiscali.co.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-man <linux-man@vger.kernel.org>
Subject: Re: man-pages text for MAV_MERGEABLE and MADV_UNMERGEABLE
Message-ID: <20100619122918.GJ18946@basil.fritz.box>
References: <AANLkTinX4TlNfvwrCtjfkU-bar3URnpvmPJB-sOi-9aT@mail.gmail.com>
 <20100619085849.GD18946@basil.fritz.box>
 <AANLkTikNEECT9CgPuCKy0h1LVKfjdXM-lavzW-TnUTz-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikNEECT9CgPuCKy0h1LVKfjdXM-lavzW-TnUTz-@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 02:22:33PM +0200, Michael Kerrisk wrote:
> Hi Andi,
> 
> On Sat, Jun 19, 2010 at 10:58 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >> +.IR len .
> >> +The KSM daemon
> >> +.RI ( ksmd )
> >
> > You should probably make clear it's a kernel thread, not a classic
> > daemon.
> 
> Thanks. I changed it to "KSM kernel thread"
> 
> >> +periodically scans those areas of user memory that have
> >> +been marked as mergeable,
> >> +looking for pages with identical content.
> >
> > Overall it seems like an internal implementation detail.
> 
> Not sure how I could improve this. Did you have some specific idea in mind?

Just dropping the sentence or using soft language like "the kernel regularly
attempts to merge pages" 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
