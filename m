Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2HIGOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:14:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51737 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2HIGOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:14:15 -0400
Date: Wed, 08 Aug 2012 23:14:14 -0700 (PDT)
Message-Id: <20120808.231414.2103406027652335204.davem@davemloft.net>
To: joe@perches.com
Cc: cjren@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca-linux-team@qualcomm.com,
        nic-devel@qualcomm.com, xiong@qca.qualcomm.com,
        hao-ran.liu@canonical.com, rodrigue@qca.qualcomm.com
Subject: Re: [PATCH] net: add new QCA alx ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344485382.2024.9.camel@joe2Laptop>
References: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
	<6349D7A510622448B1BA0967850A8438013692CA@NASANEXD02D.na.qualcomm.com>
	<1344485382.2024.9.camel@joe2Laptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 08 Aug 2012 21:09:42 -0700

> On Thu, 2012-08-09 at 02:27 +0000, Ren, Cloud wrote:
>> Hi David,
> []
>> The alx driver only supports two new nics(l1f/l2f) now.  It doesn't supersede atl1c driver.
>> Atl1c driver still supports old nics.
> []
>> -----Original Message-----
>> From: Ren, Cloud 
>> Sent: 2012年8月9日 18:15
> []
>> This driver support two new ethernet chipsets:
> 
> [+400kb of entire original patch]
> 
> Did you really have to quote 400kb of original patch to
> make that prefixing statement to David?
> 
> []
> 
>> Signed-off-by: Joe Perches <joe@perches.com>
>  
> I would prefer my name not be listed as a Signed-off-by.

You should never EVER add a signoff, or any other kind of tag, of
another person unless they give it to you explicitly.  It is beyond
rude to do this without that person's permission.

You qualcomm guys are really mishandling this patch submission,
and just like last time you are steadily pissing me off.

You have a very low level of consideration for other people who feel
the burdon of your work, and you often have no idea what the hell you
are doing.
