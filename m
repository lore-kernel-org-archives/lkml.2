Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab1FFIGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:06:02 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:37341 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab1FFIF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:05:59 -0400
Message-ID: <4DEC8A56.1030707@atmel.com>
Date: Mon, 06 Jun 2011 10:05:42 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] ATMEL, AVR32: inline nand partition table access
References: <1306676962-22308-1-git-send-email-dbaryshkov@gmail.com>	<1306935129.1097.3.camel@hcegtvedt.norway.atmel.com> <BANLkTi=s4kGg5NKrzNs1nu8S00Ue_Zv8vQ@mail.gmail.com>
In-Reply-To: <BANLkTi=s4kGg5NKrzNs1nu8S00Ue_Zv8vQ@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/06/2011 16:54, Dmitry Eremin-Solenikov :
> On 6/1/11, Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:
>> On Sun, 2011-05-29 at 17:49 +0400, Dmitry Eremin-Solenikov wrote:
>>> Currently atmel_nand driver used by AT91 and AVR32 calls a special
>>> callback
>>> which return nand partition table and number of partitions. However in all
>>> boards this callback returns just static data. So drop this callback and
>>> make atmel_nand use partition table provided statically via platform_data.
>>>
>>> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>>
>> Thanks for this update, always nice seeing code being optimized. I
>> really can't recall why it was made like this in the first place...
>>
>> For the AVR32 related parts:
>>
>> Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
>>
>> <snipp diff>
>>
>> Will this go through the linux-mtd tree (since it spans two archs) or
>> should it go through an arch tree?
> 
> On one hand, I'd prefer for this to go through the linux-mtd, if noone objects,
> as I'd also like to submit several (a pile) patches cleaning up mtd
> partitioning, which would depend on this.
> 
> OTOH, I think there will be a cleanup of AT91 platform, which would bring
> lot's of conflicts with this patch, if it goes through linux-mtd.


I am in favor for a mainline inclusion through linux-mtd tree.

On the AT91 side, we will have to take this inclusion into account to
avoid merge conflicts... But as long as this cleanup is not ready yet, I
prefer to go forward this way.

For that purpose, that would be good to see this patch in linux-next.

Thanks to all of you, bye,
-- 
Nicolas Ferre

