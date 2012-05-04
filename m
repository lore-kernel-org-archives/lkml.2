Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2EDKRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:17:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab2EDKRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:17:06 -0400
Date: Fri, 4 May 2012 11:16:59 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 00/16] Swap-over-NBD without deadlocking V9
Message-ID: <20120504101659.GK11435@suse.de>
References: <1334578624-23257-1-git-send-email-mgorman@suse.de>
 <20120501152826.b970a098.akpm@linux-foundation.org>
 <20120503150048.GI11435@suse.de>
 <20120503.130611.160512784868698446.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120503.130611.160512784868698446.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 01:06:11PM -0400, David Miller wrote:
> From: Mel Gorman <mgorman@suse.de>
> Date: Thu, 3 May 2012 16:00:48 +0100
> 
> > Any of the networking people care to comment?
> 
> Post another series with any lingering feedback you've received and
> I'll make sure it gets queued up in patchwork so that it gets properly
> reviewed by us.
> 

Will do, thanks a lot. Tests are currently running on a rebased series
and I'll post after a successful completion.

-- 
Mel Gorman
SUSE Labs
