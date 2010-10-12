Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab0JLNOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:14:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55758 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0JLNOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:14:21 -0400
Date: Tue, 12 Oct 2010 15:14:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        akpm@linux-foundation.org
Subject: Re: RFC: Implement hwpoison on free for soft offlining
Message-ID: <20101012131414.GC20436@basil.fritz.box>
References: <1286402951-1881-1-git-send-email-andi@firstfloor.org>
 <87aamj3k6f.fsf@basil.nowhere.org>
 <20101012181439.ADA9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012181439.ADA9.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To me, it's no problem if this keep 64bit only. IOW, I only dislike to
> add 32bit page flags.
> 
> Yeah, memory corruption is very crap and i think your effort has a lot
> of worth :)

Thanks.

> 
> 
> offtopic, I don't think CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_ON_FREE
> are symmetric nor easy understandable. can you please consider naming change?
> (example, CONFIG_HWPOISON/CONFIG_HWPOISON_ON_FREE, 
> CONFIG_MEMORY_FAILURE/CONFIG_MEMORY_FAILURE_SOFT_OFFLINE)

memory-failure was the old name before hwpoison as a term was invented
by Andrew.

In theory it would make sense to rename everything to "hwpoison" now.
But I decided so far the disadvantages from breaking user configurations
and the impact from renaming files far outweight the small benefits
in clarity.

So right now I prefer to keep the status quo, but name everything
new hwpoison.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
