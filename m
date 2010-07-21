Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762638Ab0GUGen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:34:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38936
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762569Ab0GUGem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:34:42 -0400
Date: Tue, 20 Jul 2010 23:34:57 -0700 (PDT)
Message-Id: <20100720.233457.267367495.davem@davemloft.net>
To: harald@redhat.com
Cc: shemminger@vyatta.com, bhutchings@solarflare.com, sassmann@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, gospo@redhat.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com,
        leedom@chelsio.com
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network
 interfaces with random MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C469313.6010807@redhat.com>
References: <20100720141816.16f0a939@nehalam>
	<20100720.142045.32697196.davem@davemloft.net>
	<4C469313.6010807@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Hoyer <harald@redhat.com>
Date: Wed, 21 Jul 2010 08:26:27 +0200

> On 07/20/2010 11:20 PM, David Miller wrote:
>> From: Stephen Hemminger<shemminger@vyatta.com>
>> Date: Tue, 20 Jul 2010 14:18:16 -0700
>>
>>> No one mentioned that the first octet of an Ethernet address already
>>> indicates "software generated" Ethernet address. Per the standard,
>>> if bit 1 is set it means address is locally assigned.
>>>
>>> static inline bool is_locally_assigned_ether(const u8 *addr)
>>> {
>>> 	return (addr[0]&  0x2) != 0;
>>> }
>>
>> W00t!
>>
>> Indeed, can udev just use that?  :-)
> 
> It already does:
> see /lib/udev/rules.d/75-persistent-net-generator.rules

So... why doesn't this work?
