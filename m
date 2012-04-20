Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2DTLMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:12:41 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2285 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754443Ab2DTLMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:12:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPZDkU95LdRK/2dsb2JhbABDsTyBCIIJAQEEATocIxALGBwSFBgNJBOICgS7C5BnBJV4kD6CeQ
Date: Fri, 20 Apr 2012 21:12:29 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] lglock: remove online variants of lock
Message-ID: <20120420111229.GG25458@amd.local0.net>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
 <20120228112422.GC11324@alboin.amr.corp.intel.com>
 <87obsbzfzm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obsbzfzm.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 05:33:41PM +1030, Rusty Russell wrote:
> Optimizing the slow paths adds a lot of complexity.  If you need to
> grab every lock often, you have other problems.

> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>


Someone might cry about online vs possible discrepancy, but
I don't really mind.

Acked-by: Nick Piggin <npiggin@kernel.dk>
