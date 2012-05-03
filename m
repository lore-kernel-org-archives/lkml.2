Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2ECPAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:00:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247Ab2ECPAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:00:52 -0400
Date: Thu, 3 May 2012 16:00:48 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 00/16] Swap-over-NBD without deadlocking V9
Message-ID: <20120503150048.GI11435@suse.de>
References: <1334578624-23257-1-git-send-email-mgorman@suse.de>
 <20120501152826.b970a098.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120501152826.b970a098.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 03:28:26PM -0700, Andrew Morton wrote:
> 
> This patchset is far less ghastly than I feared/remembered/dreamed ;)
> 

That might be the best comment the series ever received :)

> The mm parts, anyway.  Are the net guys on board with it all?

They are cc'd but have not given any feedback in a while. That could be
because they are happy with it or because if they felt the MM parts were
blocking the series then it was unnecessary to review the network parts.

Any of the networking people care to comment?

-- 
Mel Gorman
SUSE Labs
