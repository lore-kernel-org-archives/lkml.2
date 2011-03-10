Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1CJXzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:55:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49590
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab1CJXzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:55:19 -0500
Date: Thu, 10 Mar 2011 15:55:56 -0800 (PST)
Message-Id: <20110310.155556.48513201.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
References: <20110310.153444.115930379.davem@davemloft.net>
	<AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Mar 2011 15:49:40 -0800

> Grr. This has been going on for too long. Don't do it. Don't do random
> backwards merges without explanations, and with the actual source data
> removed.
> 
> We're _really_ good at doing commit messages, and the kernel commit
> log should be a great example to other projects. But in the last week
> or so, I've now _twice_ had to flame core developers for making
> totally useless commit messages.
> 
> So don't do back-merges. And if you DO do back-merges, don't make the
> commit message totally useless.
> 
> You can use either 'git commit --amend" to fix the message afterwards
> and explain WHY you did the stupid thing, or you can just do "git pull
> --no-commit" to not actually commit the merge and then write your
> commit message as you do it. But preferably you shouldn't do the
> back-merges at all.

I'm sorry about this, won't happen again.

I should have put:

	Merge to get commit 8909c9ad8ff03611c9c96c9a92656213e4bb495b
	("net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules")
	so that we can add Stephen Hemminger's fix to handle ip6 tunnels
	as well, which uses the MODULE_ALIAS_NETDEV() macro created by
	that change.

Again, sorry.
