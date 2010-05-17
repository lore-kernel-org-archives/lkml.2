Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab0EQAlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 20:41:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:57449 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0EQAlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 20:41:19 -0400
Subject: Re: [PATCH 15/35] x86, lmb: Add lmb_reserve_area_overlap_ok()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai.lu@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20100515073231.GB9877@elte.hu>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-16-git-send-email-yinghai@kernel.org>
	 <1273804337.21352.396.camel@pasglop> <4BECF158.5070200@oracle.com>
	 <1273825807.21352.601.camel@pasglop> <4BED7CE3.1020507@oracle.com>
	 <1273876234.21352.639.camel@pasglop>  <20100515073231.GB9877@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 10:39:33 +1000
Message-ID: <1274056773.21352.700.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-15 at 09:32 +0200, Ingo Molnar wrote:
> 
> Btw., it would be nice to ready the LMB core bits for 
> upstream for 2.6.35 if there's agreement about them - 
> that will make the subsequent x86 patches much easier 
> to merge.

Well, 2.6.34 was released already. I think it's a bit premature. We need
to fix a few more things (the result codes for example) and do more
testing to ensure we didn't break other archs.

Also, Yinghai wants some more changes to the core that I need to discuss
with him to understand exactly what he wants and why :-)

Cheers,
Ben.


