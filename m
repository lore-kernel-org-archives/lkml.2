Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab0HCXgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 19:36:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57066
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756529Ab0HCXgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 19:36:42 -0400
Date: Tue, 03 Aug 2010 16:37:00 -0700 (PDT)
Message-Id: <20100803.163700.71134702.davem@davemloft.net>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Xen-devel@lists.xensource.com, dongxiao.xu@intel.com
Subject: Re: [GIT PULL] xen-netfront driver updates for 2.6.36
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C586271.3010902@goop.org>
References: <4C586271.3010902@goop.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Tue, 03 Aug 2010 11:39:45 -0700

> Here's a git branch with some updates to the Xen netfront driver,
> which add a new "smartpoll" mode to the netfront backend protocol,
> which is basically equivalent to interrupt mitigation.  This merges
> cleanly with current linux-next (it previously just had a small
> constification conflict).
> 
> Do you want to take this via the net tree, or are you OK with me
> submitting them directly?

Well from my perspective:

1) It's too late to put into my tree because the merge window has
   already started.  If you want me to include this you should have
   asked me to pull it in days if not weeks ago.

2) Your tree is absolutely not in a state I can pull it.  It has lots
   of completely unrelated commits which are not in net-next-2.6 which
   in no way should I be pulling into my tree.

When you want me to take changes, your tree should be based upon mine.
And when I pull from your tree I should get only your specific
xen-netfront driver changes, and nothing more.

Thanks.
