Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0ERFca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:32:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41926
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876Ab0ERFc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:32:28 -0400
Date: Mon, 17 May 2010 22:32:37 -0700 (PDT)
Message-Id: <20100517.223237.55871633.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: shemminger@vyatta.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH -next] bridge: fix build for CONFIG_SYSFS disabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BF18468.5010005@oracle.com>
References: <20100517091756.e232bdc2.randy.dunlap@oracle.com>
	<20100517105654.2451e61f@nehalam>
	<4BF18468.5010005@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 17 May 2010 11:01:12 -0700

> On 05/17/10 10:56, Stephen Hemminger wrote:
>> On Mon, 17 May 2010 09:17:56 -0700
>> Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> 
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> Fix build when CONFIG_SYSFS is not enabled:
>>>
>>> net/bridge/br_if.c:136: error: 'struct net_bridge_port' has no member named 'sysfs_name'
>>>
>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
...
>> I don't like peppering code with #ifdef like this.
> 
> Thanks.  I didn't like it either.
> 
>> Turns out that in this place sysfs_name is always the same
>> as the device name so instead:

Stephen, please give me a formal submission of this fix with proper
signoff and credit to Randy.

Thanks!
