Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030728Ab2B2DdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 22:33:10 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52386 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021Ab2B2DdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 22:33:09 -0500
Date: Tue, 28 Feb 2012 22:32:58 -0500 (EST)
Message-Id: <20120228.223258.2261979237568571219.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: rodrigue@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca-linux-team@qualcomm.com,
        nic-devel@qualcomm.com, kgiori@qca.qualcomm.com, chris.snook@gmail.com,
        mathieu@qca.qualcomm.com, bryanh@quicinc.com
Subject: Re: [PATCH] net: add QCA alx Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <157393863283F442885425D2C454285619415561@nasanexd02a.na.qualcomm.com>
References: <157393863283F442885425D2C4542856194154FC@nasanexd02a.na.qualcomm.com>
	<20120228.212857.797446903975232476.davem@davemloft.net>
	<157393863283F442885425D2C454285619415561@nasanexd02a.na.qualcomm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 19:33:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Huang, Xiong" <xiong@qca.qualcomm.com>
Date: Wed, 29 Feb 2012 03:11:14 +0000

> We understand your concern.  To support the new chipset, do you
> think it's reasonable to upstream it as a new driver, not a
> replacement ?

It depends upon how similar the chips are.

To be honest tg3, as one example, supports quite a large array of
different pieces of hardware that use the same logical core.

So that would be my litmus test about how different a chip needs
to be to deserve an entirely new driver.

I strongly suggest you try to get atl1c working properly.
