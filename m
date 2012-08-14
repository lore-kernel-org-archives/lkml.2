Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab2HNTWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:22:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44225 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab2HNTWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:22:08 -0400
Date: Tue, 14 Aug 2012 12:22:03 -0700
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
Message-ID: <20120814192203.GY25632@google.com>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
 <20120813233520.GG25632@google.com>
 <alpine.LFD.2.02.1208142055260.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208142055260.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 14, 2012 at 09:16:16PM +0200, Thomas Gleixner wrote:
> Why the hell are you trying to rush stuff which affects a well
> maintained part of the kernel through your own tree w/o having the
> courtesy of contacting the maintainer politely instead of sending an
> ultimatum?
>
> You posted that series less than a week ago and there is no reason why
> you need to push hard on inclusion into next after a few days.

So, it has been out for a while, and it's not the final inclusion into
mainline.  The change to timer is fairly localized and you have enough
opportunity to object before and after.  It's not like I'm gonna push
it in against oppositions.

> If you really cared about my opinion you could have figured out that
> I'm on vacation.

Ah... sorry but it's not like we date or anything.

Thanks.

-- 
tejun
