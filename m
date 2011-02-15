Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1BOQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:25:29 -0500
Received: from kroah.org ([198.145.64.141]:41943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1BOQZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:25:27 -0500
Date: Tue, 15 Feb 2011 08:20:11 -0800
From: Greg KH <greg@kroah.com>
To: NeilBrown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, a.p.zijlstra@chello.nl,
        linux-tip-commits@vger.kernel.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, stable@kernel.org, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [stable] [tip:sched/core] sched: Change
 wait_for_completion_*_timeout() to return a signed long
Message-ID: <20110215162011.GA12814@kroah.com>
References: <20110105125016.64ccab0e@notabene.brown>
 <tip-6bf4123760a5aece6e4829ce90b70b6ffd751d65@git.kernel.org>
 <20110111214457.GD28537@fieldses.org>
 <20110112090707.4a794483@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112090707.4a794483@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 09:07:07AM +1100, NeilBrown wrote:
> On Tue, 11 Jan 2011 16:44:58 -0500 "J. Bruce Fields" <bfields@fieldses.org>
> wrote:
> 
> > Doesn't this belong in 2.6.37.y as well?
> 
> Yes indeed!
> I should have tagged it for Cc:stable@kernel.org in the first place.  I had
> been meaning to forward it to stable@kernel.org, but you beat me to it!

Now applied, thanks.

greg k-h
