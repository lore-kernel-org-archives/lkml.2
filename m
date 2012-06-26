Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2FZUNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:13:54 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33391 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375Ab2FZUNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:13:50 -0400
Date: Tue, 26 Jun 2012 22:13:28 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 11/16] netvm: Propagate page->pfmemalloc from
 skb_alloc_page to skb
Message-ID: <20120626201328.GI6509@breakpoint.cc>
References: <1340375443-22455-1-git-send-email-mgorman@suse.de>
 <1340375443-22455-12-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340375443-22455-12-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 03:30:38PM +0100, Mel Gorman wrote:
>  drivers/net/ethernet/chelsio/cxgb4/sge.c          |    2 +-
>  drivers/net/ethernet/chelsio/cxgb4vf/sge.c        |    2 +-
>  drivers/net/ethernet/intel/igb/igb_main.c         |    2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |    4 +-
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    3 +-
>  drivers/net/usb/cdc-phonet.c                      |    2 +-
>  drivers/usb/gadget/f_phonet.c                     |    2 +-

You did not touch all drivers which use alloc_page(s)() like e1000(e). Was
this on purpose?

Sebastian
