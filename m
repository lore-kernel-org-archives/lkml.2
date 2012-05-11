Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761129Ab2EKWIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:08:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37153 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2EKWIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:08:45 -0400
Date: Fri, 11 May 2012 18:03:28 -0400 (EDT)
Message-Id: <20120511.180328.1412689186292656882.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: bjorn@mork.no, paul.gortmaker@windriver.com, rdunlap@xenotime.net,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] net: of/phy: fix build error when phylib is built as a
 module
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FAD532E.401@gmail.com>
References: <20120510.224352.2149006669429730060.davem@davemloft.net>
	<1336751221-19127-1-git-send-email-bjorn@mork.no>
	<4FAD532E.401@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 11 May 2012 15:03:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney.cavm@gmail.com>
Date: Fri, 11 May 2012 10:58:06 -0700

> On 05/11/2012 08:47 AM, Bjørn Mork wrote:
>> CONFIG_OF_MDIO is tristate and will be m if PHYLIB is m.  Use
>> IS_ENABLED macro to prevent build error:
>>
>>   ERROR: "of_mdio_find_bus" [drivers/net/phy/mdio-mux.ko] undefined!
>>
>> Reported-by: Randy Dunlap<rdunlap@xenotime.net>
>> Cc: David Daney<david.daney@cavium.com>
>> Signed-off-by: Bjørn Mork<bjorn@mork.no>
> 
> I was able to reproduce the failure, and this patch both fixes it and
> seems correct, so...
> 
> Acked-by: David Daney<david.daney@cavium.com>

Applied.
