Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0LMDn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:43:29 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11222 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756674Ab0LMDn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:43:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJskBU15LdLl/2dsb2JhbACjf3nBCoVKBA
Date: Mon, 13 Dec 2010 14:43:22 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: scale vfsmount refcount (was Re: rcu-walk and
  dcache scaling tree update and status)
Message-ID: <20101213034322.GA7975@amd>
References: <20101213023733.GB6522@amd>
 <20101213024217.GC6522@amd>
 <20101213033110.GA7898@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213033110.GA7898@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 02:31:10PM +1100, Nick Piggin wrote:
> (Yes this little bouncing atomic hurts, badly, even on my small 2s12c
> tightly connected system on the parallel git diff workload -- because
> there are other bouncing kernel cachelines in this workload).
          ^^^
      are no other

