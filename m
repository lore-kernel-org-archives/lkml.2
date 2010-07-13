Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0GMVxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:53:52 -0400
Received: from waste.org ([173.11.57.241]:42650 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab0GMVxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:53:50 -0400
Subject: Re: [PATCH] slob_free:free objects to their own list
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Bob Liu <lliubbo@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org,
        hannes@cmpxchg.org, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <AANLkTikMcPcldBh_uVKxrH7rEIUju3Y_3X2jLi9jw2Vs@mail.gmail.com>
References: <1278756333-6850-1-git-send-email-lliubbo@gmail.com>
	 <AANLkTikMcPcldBh_uVKxrH7rEIUju3Y_3X2jLi9jw2Vs@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 16:53:47 -0500
Message-ID: <1279058027.936.236.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-13 at 20:52 +0300, Pekka Enberg wrote:
> Hi Bob,
> 
> [ Please CC me on SLOB patches. You can use the 'scripts/get_maintainer.pl'
>   script to figure out automatically who to CC on your patches. ]
> 
> On Sat, Jul 10, 2010 at 1:05 PM, Bob Liu <lliubbo@gmail.com> wrote:
> > slob has alloced smaller objects from their own list in reduce
> > overall external fragmentation and increase repeatability,
> > free to their own list also.
> >
> > Signed-off-by: Bob Liu <lliubbo@gmail.com>
> 
> The patch looks sane to me. Matt, does it look OK to you as well?

Yep, this should be a marginal improvement.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.


