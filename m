Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117Ab0FJOwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:52:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37026 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0FJOwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:52:46 -0400
Date: Thu, 10 Jun 2010 16:52:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [10/23] SCHED: Only allocate per cpu cpu mask buffer
	with offstack cpumasks
Message-ID: <20100610145243.GC19561@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org> <20100610111046.18EB4B1A2B@basil.firstfloor.org> <1276181030.2077.399.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276181030.2077.399.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch will actually break things.. please read the code.
> 
> I guess we could move the unsigned long into that block, but I really
> don't see the point.

How does it break things? 

ptr is not used for anything unless that define is set. gcc doesn't
lie on this.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
