Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab0FJA3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 20:29:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57104
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718Ab0FJA3P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 20:29:15 -0400
Date: Wed, 09 Jun 2010 17:29:25 -0700 (PDT)
Message-Id: <20100609.172925.183044544.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 -next] niu: always include of_device.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikuIgeSMC5_IzAQGEQRso4udBvBGPcioAiArWb5@mail.gmail.com>
References: <20100609.110638.112605100.davem@davemloft.net>
	<20100609154409.bf024c0c.randy.dunlap@oracle.com>
	<AANLkTikuIgeSMC5_IzAQGEQRso4udBvBGPcioAiArWb5@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 9 Jun 2010 17:45:54 -0600

> On Wed, Jun 9, 2010 at 4:44 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> The niu driver uses struct of_device when built on any arch, not
>> only SPARC64, so always #include <linux/of_device.h>.
>>
>> drivers/net/niu.c:9700: warning: 'struct of_device' declared inside parameter list
>> drivers/net/niu.c:9700: warning: its scope is only this definition or declaration, which is probably not what you want
>> drivers/net/niu.c:9716: warning: assignment from incompatible pointer type
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc:     Grant Likely <grant.likely@secretlab.ca>
>> Cc:     Dave Miller <davem@davemloft.net>
>> ---
>>  drivers/net/niu.c |    3 ---
> 
> Looks okay to me (but I haven't build tested it yet).  The bulk of
> of_device.h is compiled out when CONFIG_OF_DEVICE is not selected.
> 
> David, are you okay with me taking this via my tree as it depends on
> Randy's other patch?

Yep, that's totally fine with me:

Acked-by: David S. Miller <davem@davemloft.net>
