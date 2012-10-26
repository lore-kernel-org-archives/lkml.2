Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab2JZS7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:59:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50086 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960Ab2JZS7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:59:40 -0400
Date: Fri, 26 Oct 2012 14:59:38 -0400 (EDT)
Message-Id: <20121026.145938.2087989420370212890.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: manabian@gmail.com, netdev@vger.kernel.org, havard@skinnemoen.net,
        bhutchings@solarflare.com, linux-arm-kernel@lists.infradead.org,
        plagnioj@jcrosoft.com, patrice.vilchez@atmel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] net/macb: driver enhancement concerning GEM
 support, ring logic and cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <508AAB54.9010506@atmel.com>
References: <cover.1348055112.git.nicolas.ferre@atmel.com>
	<508AAB54.9010506@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Fri, 26 Oct 2012 17:25:08 +0200

> David,
> 
> On 09/19/2012 01:55 PM, Nicolas Ferre :
>> This is an enhancement work that began several years ago. I try to catchup with
>> some performance improvement that has been implemented then by Havard.
>> The ring index logic and the TX error path modification are the biggest changes
>> but some cleanup/debugging have been added along the way.
>> The GEM revision will benefit from the Gigabit support.
>> 
>> The series has been tested on several Atmel AT91 SoC with the two MACB/GEM
>> flavors.
>> 
>> v2: - modify the tx error handling: now uses a workqueue
>>     - information provided by ethtool -i were not accurate: removed
> 
> I am about to re-send this patch series. Should I rebase it on top of
> Joachim's recent modifications? I mean, I plan to rebase them on top of
> net-next, is it the proper thing to do?

You should always base your patch on whatever tree you want your patches
applied to.

If you have a dependency on something not in that tree (for example, you
need something in the 'net' tree) you have to tell me.
