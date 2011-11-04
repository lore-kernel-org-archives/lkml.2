Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab1KDEUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 00:20:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38605 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1KDEUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 00:20:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Nov 2011 13:19:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Message-Id: <20111104131932.ccafb402.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <785a9dc0-2f15-40bf-b9a8-e3ab28e650bd@default>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	<20111031171321.097a166c.kamezawa.hiroyu@jp.fujitsu.com>
	<ef778e79-72d0-4c58-99e8-3b36d85fa30d@default>
	<20111101095038.30289914.kamezawa.hiroyu@jp.fujitsu.com>
	<f62e02cd-fa41-44e8-8090-efe2ef052f64@default
 20111102101414.457e0a08.kamezawa.hiroyu@jp.fujitsu.com>
	<785a9dc0-2f15-40bf-b9a8-e3ab28e650bd@default>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011 08:12:01 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > > Kame, can I add you to the list of people who support
> > > merging frontswap, assuming more good performance numbers
> > > are posted?
> 
> So I'm not asking you if Fujitsu enterprise QoS-guarantee
> customers will use zcache.... Andrew said yesterday:
> 
> "At kernel summit there was discussion and overall agreement
>  that we've been paying insufficient attention to the
>  big-picture "should we include this feature at all" issues.
>  We resolved to look more intensely and critically at new
>  features with a view to deciding whether their usefulness
>  justified their maintenance burden."
> 
> I am asking you, who are an open source Linux developer and
> a respected -mm developer, do you think the usefulness
> of frontswap justifies the maintenance burden, and frontswap
> should be merged?
> 

When you convince other guys that the design is good.
At reading the whole threads, it seems other deveoppers raise
2 problems.
  1. justification of usage
  2. API design.

For 1, you'll need to show performance and benefits. I think
you tried and you'll do, again. But please take care of "2", it
seems some guys (Rik and Andrea) has concerns. 

Please CC me, I'd like to join code review process, at least.
I'd like to think of a new usage for frontswap/cleancache benficial
for enterprise users.

Thanks,
-Kame

