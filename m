Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0KIXti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:49:38 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49985 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0KIXtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:49:35 -0500
Date: Tue, 9 Nov 2010 15:48:52 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
Message-ID: <20101109234852.GC5876@outflux.net>
References: <20101025235804.GA11760@outflux.net>
 <AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
 <20101109205008.GU5876@outflux.net>
 <AANLkTint3yM44CouOvG_oA2K=_iC9AJuw-sJoB_HTUMT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTint3yM44CouOvG_oA2K=_iC9AJuw-sJoB_HTUMT@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Nov 09, 2010 at 02:46:30PM -0800, Linus Torvalds wrote:
> On Tue, Nov 9, 2010 at 12:50 PM, Kees Cook <kees.cook@canonical.com> wrote:
> > No one has committed it. I don't know why; I've sent it a few times now.
> 
> You seem to have sent it just to lkml. At least in this case the patch
> itself was not sent to me (only the subsequent replies were), and the
> choice of recipients was fairly odd apart from Andrew (who probably
> _is_ the right person).

I've been avoiding sending minor security issues like this directly to you
or security@kernel.org since that probably should be a high-priority
channel.

> 
> I don't quite see where you got the particular collection of people from.

I used scripts/get_maintainer.pl

-Kees

-- 
Kees Cook
Ubuntu Security Team
