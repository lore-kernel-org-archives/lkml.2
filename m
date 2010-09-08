Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0IHCo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:44:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36912 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab0IHCoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:44:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [BUGFIX for 2.6.36][RESEND][PATCH 1/2] oom: remove totalpage normalization from oom_badness()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1009011508440.29305@chino.kir.corp.google.com>
References: <20100831181911.87E7.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009011508440.29305@chino.kir.corp.google.com>
Message-Id: <20100907114223.C907.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  8 Sep 2010 11:44:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 31 Aug 2010, KOSAKI Motohiro wrote:
> 
> > ok, this one got no objection except original patch author.
> 
> Would you care to respond to my objections?
> 
> I replied to these two patches earlier with my nack, here they are:
> 
> 	http://marc.info/?l=linux-mm&m=128273555323993
> 	http://marc.info/?l=linux-mm&m=128337879310476
> 
> Please carry on a useful debate of the issues rather than continually 
> resending patches and labeling them as bugfixes, which they aren't.

You are still talking about only your usecase. Why do we care you? Why?
Why don't you fix the code by yourself? Why? Why do you continue selfish
development? Why? I can't understand.



> > then, I'll push it to mainline. I'm glad that I who stabilization
> > developer have finished this work.
> > 
> 
> You're not the maintainer of this code, patches go through Andrew.
> 
> That said, I'm really tired of you trying to make this personal with me; 
> I've been very respectful and accomodating during this discussion and I 
> hope that you will be the same.

As I said, You only need to don't break userland and fix the code immediately.
You don't have to expect stabilization developer allow userland and code
breakage.



