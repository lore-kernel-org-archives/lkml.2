Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab0ENWc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:32:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:60820 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab0ENWc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:32:26 -0400
Subject: Re: [PATCH 15/35] x86, lmb: Add lmb_reserve_area_overlap_ok()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BED7CE3.1020507@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-16-git-send-email-yinghai@kernel.org>
	 <1273804337.21352.396.camel@pasglop>  <4BECF158.5070200@oracle.com>
	 <1273825807.21352.601.camel@pasglop>  <4BED7CE3.1020507@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 May 2010 08:30:34 +1000
Message-ID: <1273876234.21352.639.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 09:40 -0700, Yinghai Lu wrote:
> later, after this patchset. this patchset is hanging around too long
> already.

That's where I strongly disagree with Ingo :-) There's no such thing as
a patch set hanging around too long. Patches should go in when they are
ready and in good shape, not due to some kind of time bomb, which
results in tons of unfixable crap being merged, which is very bad
engineering.

Cheers,
Ben.

