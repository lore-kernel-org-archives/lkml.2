Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1L2Rxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 12:53:51 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:39987 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754795Ab1L2Rxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 12:53:49 -0500
Message-ID: <4EFCB70C.50409@xenotime.net>
Date: Thu, 29 Dec 2011 10:53:00 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 28 (nfnetlink)
References: <20111228201806.d6de27fa2dbd9e3a3b7a2603@canb.auug.org.au> <4EFB87CC.6020105@xenotime.net> <20111228.153304.1267926241298522965.davem@davemloft.net> <20111229010330.GA2663@1984>
In-Reply-To: <20111229010330.GA2663@1984>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2011 05:03 PM, Pablo Neira Ayuso wrote:
> On Wed, Dec 28, 2011 at 03:33:04PM -0500, David Miller wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>> Date: Wed, 28 Dec 2011 13:19:08 -0800
>>
>>> On 12/28/2011 01:18 AM, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> I got bored :-(  I also hate tree wide, flag day changes :-(
>>>>
>>>> Changes since 20111222:
>>>
>>>
>>>
>>> warning: (NETFILTER_XT_MATCH_NFACCT) selects NETFILTER_NETLINK_ACCT which has unmet direct dependencies (NET && INET && NETFILTER && NETFILTER_ADVANCED)
>>>
>>> and then
>>>
>>> ERROR: "nfnetlink_subsys_unregister" [net/netfilter/nfnetlink_acct.ko] undefined!
>>> ERROR: "nfnetlink_subsys_register" [net/netfilter/nfnetlink_acct.ko] undefined!
>>>
>>>
>>> Full randconfig file is attached.
>>
>> Pablo please fix this, thanks.
> 
> Please, apply the following patch.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
