Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab1J1VId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:08:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36197 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab1J1VIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:08:32 -0400
Date: Fri, 28 Oct 2011 17:07:19 -0400 (EDT)
Message-Id: <20111028.170719.83478415752607807.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: geert@linux-m68k.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i825xx: Fix incorrect dependency for BVME6000_NET
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319835584.10258.159.camel@jtkirshe-mobl>
References: <1319835212-19473-1-git-send-email-geert@linux-m68k.org>
	<1319835584.10258.159.camel@jtkirshe-mobl>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 28 Oct 2011 14:07:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 28 Oct 2011 13:59:43 -0700

> On Fri, 2011-10-28 at 13:53 -0700, Geert Uytterhoeven wrote:
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  drivers/net/ethernet/i825xx/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/i825xx/Kconfig b/drivers/net/ethernet/i825xx/Kconfig
>> index 2be4698..ca1ae98 100644
>> --- a/drivers/net/ethernet/i825xx/Kconfig
>> +++ b/drivers/net/ethernet/i825xx/Kconfig
>> @@ -85,7 +85,7 @@ config APRICOT
>>  
>>  config BVME6000_NET
>>  	tristate "BVME6000 Ethernet support"
>> -	depends on BVME6000MVME16x
>> +	depends on BVME6000
>>  	---help---
>>  	  This is the driver for the Ethernet interface on BVME4000 and
>>  	  BVME6000 VME boards.  Say Y here to include the driver for this chip
> 
> Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied, thanks everyone.
