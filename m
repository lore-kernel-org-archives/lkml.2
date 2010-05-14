Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab0ENIO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:14:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:34583 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab0ENIO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:14:56 -0400
Subject: Re: [PATCH 05/35] x86, lmb: Add lmb_find_area_size()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BECEDAA.9070009@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-6-git-send-email-yinghai@kernel.org>
	 <1273803621.21352.368.camel@pasglop>  <4BECEDAA.9070009@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 18:13:29 +1000
Message-ID: <1273824809.21352.584.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:28 -0700, Yinghai wrote:
> 
> this just line by line translation from early_res version to lmb
> changes
> 
> please focus on lmb core at this point.

Well, the problem is that you dig into the LMB core with those functions
which means I -will- break your stuff if/when I change it, for example
to use linked lists.

Besides, the code lacks comments and explanation in the changeset. So
please provide that, I'm sure Thomas and Peter also want to understand
what's going on in the x86 side of things.

Cheers,
Ben.

