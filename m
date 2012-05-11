Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946159Ab2EKVSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:18:54 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36684 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946069Ab2EKVSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:18:52 -0400
Date: Fri, 11 May 2012 17:17:38 -0400 (EDT)
Message-Id: <20120511.171738.549587472496189783.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 10/17] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120511143218.GS11435@suse.de>
References: <1336657510-24378-11-git-send-email-mgorman@suse.de>
	<20120511.005740.210437168371869566.davem@davemloft.net>
	<20120511143218.GS11435@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 11 May 2012 14:17:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Fri, 11 May 2012 15:32:18 +0100

> On Fri, May 11, 2012 at 12:57:40AM -0400, David Miller wrote:
>> Please change this to be a static branch.
> 
> Will do. I renamed memalloc_socks to sk_memalloc_socks, made it a int as
> atomics are unnecessary and I check it directly in a branch instead of a
> static inline. It should be relatively easy for the branch predictor.

No branch predictor can beat an unconditional branch :-)
