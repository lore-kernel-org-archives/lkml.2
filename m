Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab1CHATK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 19:19:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40065 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1CHATJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 19:19:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/8] Add __GFP_OTHER_NODE flag
Cc: kosaki.motohiro@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, aarcange@redhat.com
In-Reply-To: <20110307163334.GB13384@alboin.amr.corp.intel.com>
References: <20110307173042.8A04.A69D9226@jp.fujitsu.com> <20110307163334.GB13384@alboin.amr.corp.intel.com>
Message-Id: <20110308091843.8A95.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Mar 2011 09:19:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, less intrusive. But are you using current NUMA stastics on
> > practical system?
> 
> Yes I do. I know users use it too.
> 
> We unfortunately still have enough NUMA locality problems in the kernel
> so that overflowing nodes, causing fallbacks for process memory etc. are not uncommon. 
> If you get that then numastat is very useful to track down what happens.
> 
> In an ideal world with perfect NUMA balancing it wouldn't be needed,
> but we're far from that.
> 
> Also the numactl test suite depends on them.

If so, I have no objection of cource. :)

Thanks.



