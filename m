Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1ETDGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:06:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573Ab1ETDGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:06:43 -0400
Message-ID: <4DD5DAB4.2070709@redhat.com>
Date: Fri, 20 May 2011 11:06:28 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Neil Horman <nhorman@redhat.com>, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jay Vosburgh <fubar@us.ibm.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bridge] [Patch] bridge: call NETDEV_ENSLAVE notifiers when adding
 a slave
References: <1305794393-20775-1-git-send-email-amwang@redhat.com>	<1305800661-4081-1-git-send-email-amwang@redhat.com>	<20110519081213.15c05da2@nehalam> <20110519090411.1f039a88@nehalam>
In-Reply-To: <20110519090411.1f039a88@nehalam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年05月20日 00:04, Stephen Hemminger 写道:
> On Thu, 19 May 2011 08:12:13 -0700
> Stephen Hemminger<shemminger@linux-foundation.org>  wrote:
>
>> On Thu, 19 May 2011 18:24:17 +0800
>> Amerigo Wang<amwang@redhat.com>  wrote:
>>
>>> In the previous patch I added NETDEV_ENSLAVE, now
>>> we can notify netconsole when adding a device to a bridge too.
>>>
>>> By the way, s/netdev_bonding_change/call_netdevice_notifiers/ in
>>> bond_main.c, since this is not bonding specific.
>>>
>>> Signed-off-by: WANG Cong<amwang@redhat.com>
>>> Cc: Neil Horman<nhorman@redhat.com>
>>>
>>
>> Is there a usage for this? What listens for this notification?
>
> Never mind it was in the first patch which you did not send.
> You should always put a number on group of patches and send
> to all parties.

Ah, sorry, my script simply run get_maintainers.pl to
get the Cc list, so bridge list was not in included in
the first patch.

>
> Also, sending networking patches to LKML is a waste of bandwidth
> please don't bother.

Ok, will fix my script.

Thanks.
