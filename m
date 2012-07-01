Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2GAVps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 17:45:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51713 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2GAVpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 17:45:46 -0400
Date: Sun, 01 Jul 2012 14:45:45 -0700 (PDT)
Message-Id: <20120701.144545.1360987440451468585.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: vincent.sanders@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120701151659.2be61475@pyramind.ukuu.org.uk>
References: <20120630141222.60df95a5@pyramind.ukuu.org.uk>
	<20120630.173346.670086962166528527.davem@davemloft.net>
	<20120701151659.2be61475@pyramind.ukuu.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sun, 1 Jul 2012 15:16:59 +0100

>> The issue is that what to do when a receiver goes deaf is a policy
>> issue.
> 
> Something all these protocols alredy recognize and have done for years.
> The real issue for AF_BUS versus the current slow AF_UNIX approach is
> that you really need to know *who* is blocked up.
> 
> That's no different to UDP multicast and needing to know how errored the
> frame.

And the policy on what to do about such UDP multicast errors is in
userspace, which is precisely my point.
