Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1H0PMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:12:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50312 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1H0PMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 11:12:40 -0400
Date: Sat, 27 Aug 2011 17:12:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ying.huang@intel.com
Subject: Re: using mce_inject I get: RIP 10:<ffffffffa012c909> {ttm_bo_unref+0xf/0x45 [ttm]}
Message-ID: <20110827151237.GY25996@one.firstfloor.org>
References: <4E506DEA.1070601@gmail.com> <20110821221602.GK25996@one.firstfloor.org> <4E53EB01.7080905@gmail.com> <987664A83D2D224EAE907B061CE93D5301EA5B717B@orsmsx505.amr.corp.intel.com> <4E59072A.5040108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E59072A.5040108@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 08:03:06AM -0700, Justin P. Mattock wrote:
> On 08/23/2011 01:15 PM, Luck, Tony wrote:
> >>its easily fixable, but not sure its a good idea due to bisect going
> >>through commits(afraid I might go astray with the bisect if I add any
> >>patches).
> >
> >Rather than fixing a bad build - you can try moving to a nearby commit
> >(use "gitk" to get a view of the structure around the commit that git
> >bisect suggested).  In the early stages of a bisection, it doesn't really
> >matter much if you build the mid-point that bisect provided, or some
> >nearby on - just be sure to mark good/bad the commit you actually built.
> >
> >-Tony
> >
> >
> 
> well.. after bisecting(with no results), I found that something in my 
> .config was causing this, so after looking through, I found that having 
> X86_MCE_INJECT = y causes the pauses when the timeouts occur

Seems like a bug. Copying Ying too.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
