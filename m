Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1CKAd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:33:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57514
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab1CKAd5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:33:57 -0500
Date: Thu, 10 Mar 2011 16:34:34 -0800 (PST)
Message-Id: <20110310.163434.260095615.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
References: <AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
	<20110310.155556.48513201.davem@davemloft.net>
	<AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Mar 2011 16:29:30 -0800

> On Thu, Mar 10, 2011 at 3:55 PM, David Miller <davem@davemloft.net> wrote:
>> I should have put:
>>
>>        Merge to get commit 8909c9ad8ff03611c9c96c9a92656213e4bb495b
>>        ("net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules")
>>        so that we can add Stephen Hemminger's fix to handle ip6 tunnels
>>        as well, which uses the MODULE_ALIAS_NETDEV() macro created by
>>        that change.
> 
> Yeah, that would have explained it. That said, if you are merging for
> something like that, may I suggest actually starting off with
> 
>    git merge 8909c9ad8ff03611c9c96c9a92656213e4bb495b
> 
> that then actually makes the history itself also show the relationship
> (you'd still have to write the commit message explaining why,
> otherwise git will try to be "helpful" by making the merge commit
> message be
> 
>    Merge commit '8909c9ad8ff03611c9c96c9a92656213e4bb495b'
> 
> which while _technically_ more useful and indicative of what you
> wanted to do isn't actually any more readable than the one you have
> now.
> 
> But the reason it would have been better is that it would literally
> have made the git commit parenthood point to the commit you actually
> care about.

So, this is like a cherry-pick of sorts that doesn't create new commits?
It just makes the merge commit, and that's where I explain why I need this
particular change in my tree.

Right?
