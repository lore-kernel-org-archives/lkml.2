Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1CHCnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 21:43:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57800 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab1CHCnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 21:43:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Cc: kosaki.motohiro@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110307163513.GC13384@alboin.amr.corp.intel.com>
References: <20110307172609.8A01.A69D9226@jp.fujitsu.com> <20110307163513.GC13384@alboin.amr.corp.intel.com>
Message-Id: <20110308114159.7EAD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Mar 2011 11:43:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Don't we need to make per zone stastics? I'm afraid small dma zone 
> > makes much thp-splitting and screw up this stastics.
> 
> Does it? I haven't seen that so far.
> 
> If it happens a lot it would be better to disable THP for the 16MB DMA
> zone at least. Or did you mean the 4GB zone?

I assumered 4GB. And cpusets/mempolicy binding might makes similar 
issue. It can make only one zone high pressure.

But, hmmm...
Do you mean you don't hit any issue then? I don't think do don't tested
NUMA machine. So, it has  no practical problem I can agree this.

Thanks.



