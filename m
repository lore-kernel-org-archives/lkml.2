Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1L0SCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 13:02:09 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48423 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab1L0SCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:02:06 -0500
Date: Tue, 27 Dec 2011 13:01:56 -0500 (EST)
Message-Id: <20111227.130156.1047123326718924884.davem@davemloft.net>
To: rob.herring@calxeda.com
Cc: heiko.carstens@de.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: calxeda xgmac ethernet driver add missing
 HAS_IOMEM dependency
From: David Miller <davem@davemloft.net>
In-Reply-To: <4EF9D327.3070808@calxeda.com>
References: <1324994825-4197-1-git-send-email-heiko.carstens@de.ibm.com>
	<4EF9D327.3070808@calxeda.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 27 Dec 2011 10:01:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>
Date: Tue, 27 Dec 2011 08:16:07 -0600

> On 12/27/2011 08:07 AM, Heiko Carstens wrote:
>> Fix allyesconfig build on architectures without IOMEM:
>> 
>> drivers/net/ethernet/calxeda/xgmac.c:1800:2:
>>   error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]
>> 
>> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Cc: Rob Herring <rob.herring@calxeda.com>
> 
> Thanks.
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>

Applied, thanks.
