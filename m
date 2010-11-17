Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab0KQGEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:04:13 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7767 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698Ab0KQGEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:04:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0DAIv84kx5LdurgWdsb2JhbACiQhYBARYiIsAfhUsE
Date: Wed, 17 Nov 2010 17:04:06 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101117060406.GA3928@amd>
References: <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <20101115010027.GC22876@dastard>
 <20101115042059.GB3320@amd>
 <20101116030242.GI22876@dastard>
 <20101116034906.GA4596@amd>
 <20101117011254.GJ22876@dastard>
 <20101117041812.GD3302@amd>
 <20101117055633.GA3861@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117055633.GA3861@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:56:33PM +1100, Nick Piggin wrote:
> So there. I re state my case. I have put up the numbers, and I have
> shown that even worst cases is not the end of the world. I don't know
> why I've had to repeat it so many times, but honestly at this point I've
> done enough. The case is closed until any *actual* significant numbers
> to the contrary turn up.

Same goes for per-zone LRUs, FWIW.

You can't ask submitter of every single change to prove a negative.

At some point you have to move on with life and accept that regressions
are inevitable, performance regressions are inevitable, and that we have
a development model that is well geared by now to tolerate and resolve
regressions.

