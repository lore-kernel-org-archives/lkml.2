Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab0ENIM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:12:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:56151 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab0ENIMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:12:24 -0400
Subject: Re: [PATCH 03/35] lmb: Add ARCH_DISCARD_LMB to put lmb code to
 .init
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BECEBF4.7000402@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-4-git-send-email-yinghai@kernel.org>
	 <1273803249.21352.357.camel@pasglop>  <4BECEBF4.7000402@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 18:10:23 +1000
Message-ID: <1273824623.21352.580.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:21 -0700, Yinghai wrote:
> > So you do not intend to use lmb after boot ? This will break the
> debugfs
> > files unless you also remove those.
> 
> no, x86 don't lmb after boot.
> 
> yes 

So you need some kind of CONFIG option to keep lmb after boot, at least
the data structures, for debugfs, or when not set, disable the debugfs
files.

Ben.


