Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0EQH0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 03:26:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:60157 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab0EQH03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 03:26:29 -0400
Subject: Re: [PATCH 15/35] x86, lmb: Add lmb_reserve_area_overlap_ok()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BF0DE0C.2000905@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-16-git-send-email-yinghai@kernel.org>
	 <1273804337.21352.396.camel@pasglop> <4BECF158.5070200@oracle.com>
	 <1273825807.21352.601.camel@pasglop> <4BED7CE3.1020507@oracle.com>
	 <1273876234.21352.639.camel@pasglop>  <20100515073231.GB9877@elte.hu>
	 <1274056773.21352.700.camel@pasglop>  <4BF0DE0C.2000905@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 17:24:32 +1000
Message-ID: <1274081072.21352.718.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-16 at 23:11 -0700, Yinghai wrote:
> so looks like your change will hit 2.6.35, and my x86 changes will hit
> 2.6.36?
> 
> that is too long. 

No. Both will hit 2.6.36. It's way too late to queue up such changes for
the 2.6.35 merge window which has already opened.

Why would it be "too long" ? I keep asking what the heck is going on
with having a time bomb on those patches and yet have to get a
satisfactory answer.

Cheers,
Ben.


