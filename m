Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab0D1VHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:07:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53457 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab0D1VHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:07:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
Date: Wed, 28 Apr 2010 23:08:10 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
References: <1272429119-12103-1-git-send-email-arve@android.com> <20100428194028.GA16389@redhat.com> <4BD89922.1040306@kernel.org>
In-Reply-To: <4BD89922.1040306@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004282308.10751.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010, Tejun Heo wrote:
> On 04/28/2010 09:40 PM, Oleg Nesterov wrote:
> >> +int schedule_suspend_blocking_work(struct suspend_blocking_work *work)
> >> +{
> >> ...
> >> +	ret = schedule_work(&work->work);
> > 
> > Off-topic. We should probably export keventd_wq to avoid the duplications
> > like this.
> 
> Yeah, had about the same thought.  cmwq exports it so I didn't suggest
> it at this point but then again we don't really know whether or when
> that series is going in

As soon as there are no major objections.  At least to my tree.

> so it might be a good idea to make that change now.  Hmm...

I'd rather like a follow-up patch changing that, if poss.

Thanks,
Rafael
