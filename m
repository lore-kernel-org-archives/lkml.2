Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2K1RES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:04:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50613 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2K1RER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:04:17 -0500
Date: Wed, 28 Nov 2012 12:04:15 -0500 (EST)
Message-Id: <20121128.120415.778262714601372592.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: chas@cmf.nrl.navy.mil, krzysiek@podlesie.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nathan@traverse.com.au
Subject: Re: [PATCH] br2684: don't send frames on not-ready vcc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354122070.21562.89.camel@shinybook.infradead.org>
References: <1354058916.2534.25.camel@shinybook.infradead.org>
	<20121128.114153.737074131307295783.davem@davemloft.net>
	<1354122070.21562.89.camel@shinybook.infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 28 Nov 2012 17:01:10 +0000

> On Wed, 2012-11-28 at 11:41 -0500, David Miller wrote:
>> 
>> Please:
>> 
>>         if (X ||
>>             Y ||
>>             Z)
>> 
>> not:
>> 
>>         if (X
>>             || Y
>>             || Z)
> 
> Thanks. Fixed in both Krzysztof's original pppoatm version, and my
> br2684 patch, in the git tree at git://git.infradead.org/~dwmw2/atm.git
> 
> I knew there was something else that offended me about the original,
> other than just the whitespace (which is also fixed).

Do you want me to pull that tree into net-next or is there a plan to
repost the entire series of work for a final submission?
