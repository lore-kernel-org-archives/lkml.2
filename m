Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab0DPU37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 16:29:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43318
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932415Ab0DPU35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 16:29:57 -0400
Date: Fri, 16 Apr 2010 13:30:01 -0700 (PDT)
Message-Id: <20100416.133001.262206466.davem@davemloft.net>
To: penguin-kernel@I-love.SAKURA.ne.jp
Cc: amwang@redhat.com, sean.hefty@intel.com, opurdila@ixiacom.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org, rolandd@cisco.com,
       linux-rdma@vger.kernel.org
Subject: Re: [PATCH] rdma/cm: Randomize local port allocation.
From: David Miller <davem@davemloft.net>
In-Reply-To: <201004162254.FJF73478.SHOOMOFtQFVJLF@I-love.SAKURA.ne.jp>
References: <5CE6BC7B954643FAAFFD2AD66F673CBD@amr.corp.intel.com>
	<4BC7C9CF.20403@redhat.com>
	<201004162254.FJF73478.SHOOMOFtQFVJLF@I-love.SAKURA.ne.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 16 Apr 2010 22:54:22 +0900

> Cong Wang wrote:
>> Sean Hefty wrote:
>> > I like this version, thanks!  I'm not sure which tree to merge it through.
>> > Are you needing this for 2.6.34, or is 2.6.35 okay?
>> > 
>> 
>> As soon as possible, so 2.6.34. :)
>> 
> Cong, merge window for 2.6.34 was already closed.
> You need to make your patchset towards 2.6.35 (using net-next-2.6 tree)
> rather than 2.6.34 (using linux-2.6 tree). Therefore, this patch being
> queued for 2.6.35 (through net-next-2.6 tree) should be okay for you.

I don't take RDMA patches into net-next-2.6, the less I touch this
stack avoiding stuff the better and Roland has been taking this stuff
into his own tree for some time now.
