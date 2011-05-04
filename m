Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1EDWL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 18:11:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39410 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1EDWL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 18:11:26 -0400
Date: Thu, 5 May 2011 00:11:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, rientjes@google.com,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] Allocate memory cgroup structures in local nodes v2 II
Message-ID: <20110504221125.GB2925@one.firstfloor.org>
References: <1304540783-8247-1-git-send-email-andi@firstfloor.org> <20110504213850.GA16685@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504213850.GA16685@cmpxchg.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> alloc_pages_exact_node takes an order, not a size argument.
> 
> alloc_pages_exact_node returns a pointer to the struct page, not to
> the allocated memory, like all other alloc_pages* functions with the
> exception of alloc_pages_exact.

In addition to all of this it's also not exact, but just a normal
order of two allocation.

-Andi
