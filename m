Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0KJAn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:43:58 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40696 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab0KJAn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:43:56 -0500
Date: Tue, 9 Nov 2010 16:43:47 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Security] [PATCH v3 0/4] x86: clear XD_DISABLED flag on Intel
 to regain NX
Message-ID: <20101110004347.GF5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
 <20101109183142.4ebfa737@lxorguk.ukuu.org.uk>
 <20101109185604.GK5876@outflux.net>
 <20101109225000.1b90e720@lxorguk.ukuu.org.uk>
 <20101109235314.GD5876@outflux.net>
 <20101110002153.7af92a1f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110002153.7af92a1f@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 12:21:53AM +0000, Alan Cox wrote:
> > Only Intel has this problem (it's the only CPU that defines this MSR), so
> > that'll reduce it. But Google is of no help to me on this; where can I find
> > these documents?
> 
> www.intel.com 8)

Gee, thanks. :P

I looks like there is nothing that actually lists errata directly, so
walking the entire site for lists of all processor types, e.g.:
http://www.intel.com/products/processors/previousgeneration/index.htm
http://www.intel.com/design/celeron/documentation.htm
and then checking spec updates is the only way to go.

> > > I'm not specifically aware of any but I do know for example that there
> > > are other CPU BIOS disablable features that some systems disable in the
> > > BIOS for good reason (an ancient example being the original Pentium
> > > REP MOVS optimisation on some steppings)
> > 
> > By definition there should be fewer errata CPUs than those than need their
> > BIOS ignored, so I still think this patch makes sense (especially since it
> > can trivially be worked around with the noexec=off boot option).
> 
> We need to be sure because the last thing you want is even 1% of your 10%
> of users to sudden get magical random memory corruption from overriding
> something wrongly !
> 
> It's definitely worth checking and worth doing because even if there is
> one (and I have no idea if there is) it'll tell you which steppings

I will report if I find anything bad.

-Kees

-- 
Kees Cook
Ubuntu Security Team
