Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1EDVnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:43:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48709 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1EDVm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:42:59 -0400
Date: Wed, 4 May 2011 23:42:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, rientjes@google.com,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] Allocate memory cgroup structures in local nodes v2
Message-ID: <20110504214256.GA2925@one.firstfloor.org>
References: <1304540783-8247-1-git-send-email-andi@firstfloor.org> <20110504213850.GA16685@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504213850.GA16685@cmpxchg.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think any of those mistakes even triggers a compiler warning.
> Wow.  This API is so thoroughly fscked beyond belief that I think the
> only way to top this is to have one of the functions invert the bits
> of its return value depending on the parity of the uptime counter.

Yes I must agree. Oops. Ok I'm retracting the patch for now
and do more testing (i think it just hit the fallback)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
