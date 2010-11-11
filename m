Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab0KKD4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:56:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932393Ab0KKD4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:56:33 -0500
Date: Wed, 10 Nov 2010 19:53:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kosaki.motohiro@jp.fujitsu.com, kevin.granade@gmail.com
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average
 (EWMA) function
Message-Id: <20101110195329.d456e29b.akpm@linux-foundation.org>
In-Reply-To: <20101111034756.15014.2156.stgit@localhost6.localdomain6>
References: <20101111034756.15014.2156.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010 12:47:56 +0900 Bruno Randolf <br1@einfach.org> wrote:

> This adds generic functions for calculating Exponentially Weighted Moving
> Averages (EWMA). This implementation makes use of a structure which keeps the
> EWMA parameters and a scaled up internal representation to reduce rounding
> errors.
> 
> The original idea for this implementation came from the rt2x00 driver
> (rt2x00link.c). I would like to use it in several places in the mac80211 and
> ath5k code and I hope it can be useful in many other places in the kernel code.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> --
> 
> Excuse me, but can I expect this to be merged anytime soon? Where do I check if
> it got merged? I'm resending the patch in case it got lost.

Yes, sorry, this is buried in my exponentially increasing backlog. 
It's going to take me a while to catch up again.

Unless I just merge stuff without looking at it.  hm, I wonder if that
would make any difference??

> +/**
> + * DOC: Exponentially Weighted Moving Average (EWMA)
> + *
> + * These are generic functions for calculating Exponentially Weighted Moving
> + * Averages (EWMA). We keep a structure with the EWMA parameters and a scaled
> + * up internal representation of the average value to prevent rounding errors.
> + * The factor for scaling up and the exponential weight (or decay rate) have to
> + * be specified thru the init fuction. The structure should not be accessed
> + * directly but only thru the helper functions.
> + */

<reads Documentation/kernel-doc-nano-HOWTO.txt>

Well, I never knew about "DOC:".
