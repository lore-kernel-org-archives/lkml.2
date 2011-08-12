Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1HLGT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 02:19:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34426 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1HLGT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:19:26 -0400
Date: Thu, 11 Aug 2011 23:17:22 -0700 (PDT)
Message-Id: <20110811.231722.39489164496412086.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next] spider_net: fix compile issue introduced by driver
 move
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313129511.4588.8.camel@jtkirshe-mobl>
References: <20110811.230017.1431877798231142541.davem@davemloft.net>
	<20110811.230552.837691497153518712.davem@davemloft.net>
	<1313129511.4588.8.camel@jtkirshe-mobl>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 23:17:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 11 Aug 2011 23:11:50 -0700

> On Thu, 2011-08-11 at 23:05 -0700, David Miller wrote:
>> From: David Miller <davem@davemloft.net>
>> Date: Thu, 11 Aug 2011 23:00:17 -0700 (PDT)
>> 
>> > From: Stephen Rothwell <sfr@canb.auug.org.au>
>> > Date: Fri, 12 Aug 2011 15:00:03 +1000
>> > 
>> >> However, Dave, I now get these (powerpc ppc64defconfig build of just the
>> >> net tree):
>> > 
>> > This should fix the cxgbi scsi problems, I'll work on the mlx4 ones
>> > next.
>> 
>> And this one will fix the mlx4 infiniband problems, thanks Stephen.
> 
> Are you working on the cxgb3/4 infiniband errors as well?  The fix is
> similar to the fix below.

Those do not need a fix, their Kconfig fragments don't select things
they "depend" upon them so they are fine.
