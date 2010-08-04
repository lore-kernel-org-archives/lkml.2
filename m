Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab0HDAtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 20:49:50 -0400
Received: from claw.goop.org ([74.207.240.146]:33781 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877Ab0HDAtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 20:49:49 -0400
Message-ID: <4C58B92A.4090605@goop.org>
Date: Tue, 03 Aug 2010 17:49:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Xen-devel@lists.xensource.com, dongxiao.xu@intel.com
Subject: Re: [GIT PULL] xen-netfront driver updates for 2.6.36
References: <4C586271.3010902@goop.org> <20100803.163700.71134702.davem@davemloft.net>
In-Reply-To: <20100803.163700.71134702.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/03/2010 04:37 PM, David Miller wrote:
> From: Jeremy Fitzhardinge<jeremy@goop.org>
> Date: Tue, 03 Aug 2010 11:39:45 -0700
>
>> Here's a git branch with some updates to the Xen netfront driver,
>> which add a new "smartpoll" mode to the netfront backend protocol,
>> which is basically equivalent to interrupt mitigation.  This merges
>> cleanly with current linux-next (it previously just had a small
>> constification conflict).
>>
>> Do you want to take this via the net tree, or are you OK with me
>> submitting them directly?
> Well from my perspective:
>
> 1) It's too late to put into my tree because the merge window has
>     already started.  If you want me to include this you should have
>     asked me to pull it in days if not weeks ago.

OK, there's no particular rush.

> 2) Your tree is absolutely not in a state I can pull it.  It has lots
>     of completely unrelated commits which are not in net-next-2.6 which
>     in no way should I be pulling into my tree.

It's based on v2.6.35.  I can rebase to net-next-2.6.

> When you want me to take changes, your tree should be based upon mine.
> And when I pull from your tree I should get only your specific
> xen-netfront driver changes, and nothing more.

Sure.

Thanks,
     J
