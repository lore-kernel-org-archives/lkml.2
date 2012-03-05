Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2CEHII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:08:08 -0500
Received: from ozlabs.org ([203.10.76.45]:44348 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab2CEHIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:08:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
In-Reply-To: <20120228112422.GC11324@alboin.amr.corp.intel.com>
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228112422.GC11324@alboin.amr.corp.intel.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 05 Mar 2012 17:32:53 +1030
Message-ID: <87sjhnzg0y.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 03:24:22 -0800, Andi Kleen <ak@linux.intel.com> wrote:
> Rusty: you should probably have cocci rules for this stuff, not manual
> patches.

Yes, though hopefully this is the last.

I've updated your patch based on Ingo's peevish feedback and a patch
to rip out the online stuff; posting now...

Thanks,
Rusty.
-- 
  Please can you help my fiance Alex?  http://baldalex.org
