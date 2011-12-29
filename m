Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1L2Tm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 14:42:58 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36279 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1L2Tmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 14:42:55 -0500
Date: Thu, 29 Dec 2011 14:39:44 -0500 (EST)
Message-Id: <20111229.143944.1971586044787221232.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: pablo@netfilter.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 28 (nfnetlink)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4EFCB70C.50409@xenotime.net>
References: <20111228.153304.1267926241298522965.davem@davemloft.net>
	<20111229010330.GA2663@1984>
	<4EFCB70C.50409@xenotime.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 29 Dec 2011 11:39:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Thu, 29 Dec 2011 10:53:00 -0800

> On 12/28/2011 05:03 PM, Pablo Neira Ayuso wrote:
>> On Wed, Dec 28, 2011 at 03:33:04PM -0500, David Miller wrote:
>>> From: Randy Dunlap <rdunlap@xenotime.net>
>>> Date: Wed, 28 Dec 2011 13:19:08 -0800
>>>
>>>> On 12/28/2011 01:18 AM, Stephen Rothwell wrote:
>>>>> Hi all,
>>>>>
>>>>> I got bored :-(  I also hate tree wide, flag day changes :-(
>>>>>
>>>>> Changes since 20111222:
>>>>
>>>>
>>>>
>>>> warning: (NETFILTER_XT_MATCH_NFACCT) selects NETFILTER_NETLINK_ACCT which has unmet direct dependencies (NET && INET && NETFILTER && NETFILTER_ADVANCED)
>>>>
>>>> and then
>>>>
>>>> ERROR: "nfnetlink_subsys_unregister" [net/netfilter/nfnetlink_acct.ko] undefined!
>>>> ERROR: "nfnetlink_subsys_register" [net/netfilter/nfnetlink_acct.ko] undefined!
>>>>
>>>>
>>>> Full randconfig file is attached.
>>>
>>> Pablo please fix this, thanks.
>> 
>> Please, apply the following patch.
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Applied, thanks everyone.
