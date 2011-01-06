Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1AFTRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 14:17:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38466
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab1AFTRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:17:49 -0500
Date: Thu, 06 Jan 2011 11:18:20 -0800 (PST)
Message-Id: <20110106.111820.39176204.davem@davemloft.net>
To: florian@openwrt.org
Cc: axel.lin@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: r6040: Return proper error for r6040_init_one
From: David Miller <davem@davemloft.net>
In-Reply-To: <201101051050.45381.florian@openwrt.org>
References: <1294216804.19064.2.camel@mola>
	<201101051050.45381.florian@openwrt.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>
Date: Wed, 5 Jan 2011 10:50:45 +0100

> On Wednesday 05 January 2011 09:40:04 Axel Lin wrote:
>> Return -ENOMEM instead of 0 for the case of mdiobus_alloc and kmalloc
>> failure.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Florian Fainelli <florian@openwrt.org>

Applied, thanks.
