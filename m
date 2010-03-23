Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab0CWBqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 21:46:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab0CWBqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:46:17 -0400
Message-ID: <4BA81E1C.7070400@redhat.com>
Date: Tue, 23 Mar 2010 09:49:16 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Andy Gospodarek <andy@greyhouse.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, Andy Gospodarek <gospo@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC Patch 3/3] bonding: make bonding support netpoll
References: <20100322082059.4967.63492.sendpatchset@localhost.localdomain> <20100322082123.4967.77433.sendpatchset@localhost.localdomain> <20100323005639.GH2108@gospo.rdu.redhat.com>
In-Reply-To: <20100323005639.GH2108@gospo.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Gospodarek wrote:
> On Mon, Mar 22, 2010 at 04:17:40AM -0400, Amerigo Wang wrote:
>> Based on Andy's work, but I modify a lot.
>>
>> Similar to the patch for bridge, this patch does:
>>
>> 1) implement the 4 methods to support netpoll for bonding;
>>
>> 2) modify netpoll during forwarding packets in bonding;
>>
>> 3) disable netpoll support of bridge when a netpoll-unabled device
>>    is added to bonding;
>>
>> 4) enable netpoll support when all underlying devices support netpoll.
>>
>> Cc: Andy Gospodarek <gospo@redhat.com>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
>> Cc: Jay Vosburgh <fubar@us.ibm.com>
>> Cc: David Miller <davem@davemloft.net>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>>
> 
> How much testing was done on this?
> 
> One of the potential problems with this code is how gracefully the
> system can handle tear-down of interfaces or removal of the bonding
> module when netconsole is active.  Was that tested heavily?
> 

For this case you mention, I did test it, but what I did is mainly basic
functionality testing, including bonding over bridge and bridge over bonding.

Thanks!
