Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1GGS4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:56:08 -0400
Received: from waste.org ([173.11.57.241]:51376 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab1GGS4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:56:03 -0400
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, rientjes@google.com,
        linux-mm@kvack.org
In-Reply-To: <1310064771.21902.55.camel@jaguar>
References: <20110626193918.GA3339@joi.lan>
	 <alpine.DEB.2.00.1107072106560.6693@tiger>
	 <alpine.DEB.2.00.1107071314320.21719@router.home>
	 <1310064771.21902.55.camel@jaguar>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 13:55:59 -0500
Message-ID: <1310064959.3637.12.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 21:52 +0300, Pekka Enberg wrote:
> On Thu, 7 Jul 2011, Pekka Enberg wrote:
> > > Looks good to me. Christoph, David, ?
> 
> On Thu, 2011-07-07 at 13:17 -0500, Christoph Lameter wrote:
> > The reason debug code is there is because it is useless overhead typically
> > not needed. There is no point in optimizing the code that is not run in
> > production environments unless there are gross performance issues that
> > make debugging difficult. A performance patch for debugging would have to
> > cause significant performance improvements. This patch does not do that
> > nor was there such an issue to be addressed in the first place.
> 
> Is there something technically wrong with the patch? Quoting the patch
> email:
> 
>   (Compiling some project with different options)
>                                  make -j12    make clean
>   slub_debug disabled:             1m 27s       1.2 s
>   slub_debug enabled:              1m 46s       7.6 s
>   slub_debug enabled + this patch: 1m 33s       3.2 s
> 
>   check_bytes still shows up high, but not always at the top.
> 
> That's significant enough speedup for me!

We're not going to make any progress on this; Christoph conveniently
forgets the counterarguments from week to week.

-- 
Mathematics is the supreme nostalgia of our time.


