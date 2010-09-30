Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0I3Crq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:47:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34991
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360Ab0I3Crp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:47:45 -0400
Date: Wed, 29 Sep 2010 19:48:05 -0700 (PDT)
Message-Id: <20100929.194805.68142212.davem@davemloft.net>
To: jgarzik@pobox.com
Cc: linux@rainbow-software.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] de2104x: remove experimental status
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CA23963.8040409@pobox.com>
References: <201009282046.21279.linux@rainbow-software.org>
	<4CA23963.8040409@pobox.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Tue, 28 Sep 2010 14:52:19 -0400

> On 09/28/2010 02:46 PM, Ondrej Zary wrote:
>> It should be ready after 8 years...remove the experimental dependency.
>>
>> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
>>
>> --- linux-2.6.36-rc3-/drivers/net/tulip/Kconfig 2010-08-29
>> --- 17:36:04.000000000 +0200
>> +++ linux-2.6.36-rc3/drivers/net/tulip/Kconfig 2010-09-28
>> 19:49:46.000000000 +0200
>> @@ -11,8 +11,8 @@ menuconfig NET_TULIP
>>   if NET_TULIP
>>
>>   config DE2104X
>> -	tristate "Early DECchip Tulip (dc2104x) PCI support (EXPERIMENTAL)"
>> -	depends on PCI&&  EXPERIMENTAL
>> +	tristate "Early DECchip Tulip (dc2104x) PCI support"
>> +	depends on PCI
>>   	select CRC32
>>   	---help---
>>   	  This driver is developed for the SMC EtherPower series Ethernet
> 
> Well...  it's not the years, it's the quality...  which I think has
> been sufficiently increased.
> 
> Acked-by: Jeff Garzik <jgarzik@redhat.com>

Also applied to net-next-2.6, thanks.
