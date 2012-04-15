Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2DOG5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 02:57:23 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59864 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2DOG5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 02:57:21 -0400
Date: Sun, 15 Apr 2012 08:57:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
Message-ID: <20120415065715.GD29563@gmail.com>
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org>
 <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
 <20120414005921.GA22114@infradead.org>
 <20120414084616.GA28505@gmail.com>
 <1334467743.7802.17.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334467743.7802.17.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Sat, 2012-04-14 at 10:46 +0200, Ingo Molnar wrote:
> 
> > I suspect the default view should be the 'most intelligent' 
> > mode of assembly output we can offer - with easy toggles for 
> > the rare cases where someone would like to do something 
> > special, plus .perfconfig overrides for those with weird 
> > workflows and those with a taste different from ours.
> 
> Maybe you just said that, but it sounded like the opposite.  
> If 'most intelligent' means maximum circles and arrows for 
> dummies, I agree ;-)

LOL, yeah - I think the output that is the most obvious one to 
people versed in those concepts but not intimitely familiar with 
that specific output tends to be pretty close to the most 
intelligent one.

Thanks,

	Ingo
