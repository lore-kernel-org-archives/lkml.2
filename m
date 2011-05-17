Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab1EQSAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:00:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45622 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab1EQSAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:00:38 -0400
Date: Tue, 17 May 2011 14:00:04 -0400 (EDT)
Message-Id: <20110517.140004.2294213911709293397.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: segoon@openwall.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ping: fix build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110517084125.77b543c8.randy.dunlap@oracle.com>
References: <20110516.153844.1072050131335197211.davem@davemloft.net>
	<20110517101656.GA28685@albatros>
	<20110517084125.77b543c8.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 May 2011 11:00:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 17 May 2011 08:41:25 -0700

> On Tue, 17 May 2011 14:16:56 +0400 Vasiliy Kulikov wrote:
> 
>> On Mon, May 16, 2011 at 15:38 -0400, David Miller wrote:
>> > From: Randy Dunlap <randy.dunlap@oracle.com>
>> > Date: Mon, 16 May 2011 12:35:34 -0700
>> > 
>> > > On Mon, 16 May 2011 15:10:19 +1000 Stephen Rothwell wrote:
>> > > when CONFIG_PROC_SYSCTL is not enabled:
>> > > 
>> > > ping.c:(.text+0x52af3): undefined reference to `inet_get_ping_group_range_net'
>> > 
>> > Vasiliy, please fix this.
>> 
>> I wonder whether there is any way to test such unusual configurations?
>> Only randconfig or are there any (partly-)automated tools for it?
>> 
>> 
>> [PATCH] net: ping: fix build failure
>> 
>> If CONFIG_PROC_SYSCTL=n the building process fails:
>> 
>>     ping.c:(.text+0x52af3): undefined reference to `inet_get_ping_group_range_net'
>> 
>> Moved inet_get_ping_group_range_net() to ping.c.
>> 
>> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks everyone.
