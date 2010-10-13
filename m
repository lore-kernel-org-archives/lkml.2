Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0JMAPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 20:15:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35177 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab0JMAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 20:15:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: RFC: Implement hwpoison on free for soft offlining
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        akpm@linux-foundation.org
In-Reply-To: <20101012131414.GC20436@basil.fritz.box>
References: <20101012181439.ADA9.A69D9226@jp.fujitsu.com> <20101012131414.GC20436@basil.fritz.box>
Message-Id: <20101013091553.ADB1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 Oct 2010 09:15:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > To me, it's no problem if this keep 64bit only. IOW, I only dislike to
> > add 32bit page flags.
> > 
> > Yeah, memory corruption is very crap and i think your effort has a lot
> > of worth :)
> 
> Thanks.
> 
> > 
> > 
> > offtopic, I don't think CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_ON_FREE
> > are symmetric nor easy understandable. can you please consider naming change?
> > (example, CONFIG_HWPOISON/CONFIG_HWPOISON_ON_FREE, 
> > CONFIG_MEMORY_FAILURE/CONFIG_MEMORY_FAILURE_SOFT_OFFLINE)
> 
> memory-failure was the old name before hwpoison as a term was invented
> by Andrew.
> 
> In theory it would make sense to rename everything to "hwpoison" now.
> But I decided so far the disadvantages from breaking user configurations
> and the impact from renaming files far outweight the small benefits
> in clarity.
> 
> So right now I prefer to keep the status quo, but name everything
> new hwpoison.

ok. I've got it. thanks :)


