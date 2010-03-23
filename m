Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0CWCBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:01:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab0CWCA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:00:59 -0400
Message-ID: <4BA82186.3010204@redhat.com>
Date: Tue, 23 Mar 2010 10:03:50 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, Andy Gospodarek <gospo@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC Patch 2/3] bridge: make bridge support netpoll
References: <20100322082059.4967.63492.sendpatchset@localhost.localdomain>	 <20100322082112.4967.5504.sendpatchset@localhost.localdomain> <1269297307.3552.23.camel@calx>
In-Reply-To: <1269297307.3552.23.camel@calx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, 2010-03-22 at 04:17 -0400, Amerigo Wang wrote:
>> Based on the previous patch, make bridge support netpoll by:
>>
>> 1) implement the 4 methods to support netpoll for bridge;
>>
>> 2) modify netpoll during forwarding packets in bridge;
>>
>> 3) disable netpoll support of bridge when a netpoll-unabled device
>>    is added to bridge;
> 
> Not sure if this is the right thing to do. Shouldn't we simply enable
> polling on all devices that support it and warn about the others (aka
> best effort)?
> 

I don't think it's a good idea, because we check if a device
supports netpoll by checking if it has ndo_poll_controller method.

Thanks.

