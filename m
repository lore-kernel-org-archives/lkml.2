Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab0K3NAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 08:00:52 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38987 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0K3NAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 08:00:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2]mm/oom-kill: direct hardware access processes should get bonus
Cc: kosaki.motohiro@jp.fujitsu.com, "Figo.zhang" <figo1802@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1011271733460.3764@chino.kir.corp.google.com>
References: <20101123154843.7B8D.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011271733460.3764@chino.kir.corp.google.com>
Message-Id: <20101130220107.8328.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Nov 2010 22:00:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 23 Nov 2010, KOSAKI Motohiro wrote:
> 
> > > > > I think in cases of heuristics like this where we obviously want to give 
> > > > > some bonus to CAP_SYS_ADMIN that there is consistency with other bonuses 
> > > > > given elsewhere in the kernel.
> > > > 
> > > > Keep comparision apple to apple. vm_enough_memory() account _virtual_ memory.
> > > > oom-killer try to free _physical_ memory. It's unrelated.
> > > > 
> > > 
> > > It's not unrelated, the LSM function gives an arbitrary 3% bonus to 
> > > CAP_SYS_ADMIN.  
> > 
> > Unrelated. LSM _is_ security module. and It only account virtual memory.
> > 
> 
> I needed a small bias for CAP_SYS_ADMIN tasks so I chose 3% since it's the 
> same proportion used elsewhere in the kernel and works nicely since the 
> badness score is now a proportion.  

Why? Is this important than X?

> If you'd like to propose a different 
> percentage or suggest removing the bias for root tasks altogether, feel 
> free to propose a patch.  Thanks!

I only need to revert bad change.


Thanks.



