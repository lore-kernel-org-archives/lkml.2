Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1CGQdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:33:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:63736 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1CGQdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:33:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,277,1297065600"; 
   d="scan'208";a="894650717"
Date: Mon, 7 Mar 2011 08:33:34 -0800
From: Andi Kleen <ak@linux.intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com
Subject: Re: [PATCH 6/8] Add __GFP_OTHER_NODE flag
Message-ID: <20110307163334.GB13384@alboin.amr.corp.intel.com>
References: <1299182391-6061-1-git-send-email-andi@firstfloor.org>
 <1299182391-6061-7-git-send-email-andi@firstfloor.org>
 <20110307173042.8A04.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307173042.8A04.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, less intrusive. But are you using current NUMA stastics on
> practical system?

Yes I do. I know users use it too.

We unfortunately still have enough NUMA locality problems in the kernel
so that overflowing nodes, causing fallbacks for process memory etc. are not uncommon. 
If you get that then numastat is very useful to track down what happens.

In an ideal world with perfect NUMA balancing it wouldn't be needed,
but we're far from that.

Also the numactl test suite depends on them.


-Andi
