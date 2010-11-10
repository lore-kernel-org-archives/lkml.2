Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0KJBDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:03:35 -0500
Received: from mail.perches.com ([173.55.12.10]:4880 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab0KJBDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:03:32 -0500
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees.cook@canonical.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <AANLkTinCLMGWWD=8do9pv0vnFMX8njYyNgsMS+VeRfpQ@mail.gmail.com>
References: <20101025235804.GA11760@outflux.net>
	 <AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
	 <20101109205008.GU5876@outflux.net>
	 <AANLkTint3yM44CouOvG_oA2K=_iC9AJuw-sJoB_HTUMT@mail.gmail.com>
	 <20101109234852.GC5876@outflux.net>
	 <AANLkTinCLMGWWD=8do9pv0vnFMX8njYyNgsMS+VeRfpQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 17:03:30 -0800
Message-ID: <1289351010.28590.81.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 16:54 -0800, Linus Torvalds wrote:
> On Tue, Nov 9, 2010 at 3:48 PM, Kees Cook <kees.cook@canonical.com> wrote:
> >> I don't quite see where you got the particular collection of people from.
> > I used scripts/get_maintainer.pl
> Hmm. I get totally different results. You had
>   linux-kernel@vger.kernel.org
>   Al Viro <viro@zeniv.linux.org.uk>,
>   Andrew Morton <akpm@linux-foundation.org>,
>   Jiri Slaby <jslaby@suse.cz>,
>   "David S. Miller" <davem@davemloft.net>
> and I get
>   Al Viro <viro@ZenIV.linux.org.uk>
>   Andrew Morton <akpm@linux-foundation.org>
>   Helge Deller <deller@gmx.de>
>   David Howells <dhowells@redhat.com>
>   Hugh Dickins <hughd@google.com>
>   linux-kernel@vger.kernel.org
> so there is something odd going on there.

I'd like to know as well.

