Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab0ENIRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:17:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:34621 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229Ab0ENIRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:17:37 -0400
Subject: Re: [PATCH 08/35] x86,lmb: Add lmb_reserve_area/lmb_free_area
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BECEE23.3080904@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-9-git-send-email-yinghai@kernel.org>
	 <1273803964.21352.380.camel@pasglop>  <4BECEE23.3080904@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 18:15:20 +1000
Message-ID: <1273824920.21352.586.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:30 -0700, Yinghai wrote:
> make the rebase more easy.
> 
> previous version is using those api.
> 
> also will add some debug print out with them 

No. Get rid of them.

If any of those checks/debug is worth having in the API it's worth
having it for all archs.

At -worst-, Thomas and Peter may be ok with having inline wrappers for
the argument style conversion in x86 lmb.h but I somewhat doubt it.

In the form of non-inline exported functions with such confusing naming
and semantics (and total lack of documentation or explanation), this is
just wrong.

Cheers,
Ben.


