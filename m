Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab0KKAaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:30:01 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:15373 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586Ab0KKAaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:30:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAfF2kx5LcZK/2dsb2JhbACiPHK/cYVKBI9m
Date: Thu, 11 Nov 2010 11:29:57 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Salman Qazi <sqazi@google.com>
Cc: Nick Piggin <npiggin@kernel.dk>, paulmck@us.ibm.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, adurbin@google.com
Subject: Re: [PATCH] Fixed a mismatch between the users of radix_tree and
 the implementation.
Message-ID: <20101111002957.GB3477@amd>
References: <1281957914.1926.1249.camel@laptop>
 <20100816182834.3541.42317.stgit@bumblebee1.mtv.corp.google.com>
 <20100817152352.GA10785@amd>
 <AANLkTimYJ3KfHfd9dFWinowm+J7KdM0dtt-wMU9Rv9=o@mail.gmail.com>
 <AANLkTimKokqHoQ0GGKuN1frbz7BrYJV9iQZ12Y111329@mail.gmail.com>
 <AANLkTi=hFPFHyZC3tpkF4mOgUYa+B_eVPdeKq-BwVaB9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=hFPFHyZC3tpkF4mOgUYa+B_eVPdeKq-BwVaB9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 11:16:21AM -0800, Salman Qazi wrote:
> On Mon, Aug 30, 2010 at 4:27 PM, Salman Qazi <sqazi@google.com> wrote:
> > On Tue, Aug 17, 2010 at 2:28 PM, Salman Qazi <sqazi@google.com> wrote:
> >> > -               if (unlikely(page == RADIX_TREE_RETRY))
> >> > +               if (radix_tree_deref_retry(page))
> >> >                        goto restart;
> >> >
> >> >                if (!page_cache_get_speculative(page))
> >> >
> >>
> >> I just verified that your patch fixes the issue.  Thanks for doing this.
> >
> > Are we going to proceed with this?
> >
> 
> 
> This bug is still unresolved.  Can we please follow this patch through
> to conclusion?

Yep, I'm about 30 minutes ahead of you (if you ignore the couple of
months I am behind).

I forgot to add you to cc, sorry -- patch just went to lkml and Linus.

Thanks for following up.

Thanks,
Nick
