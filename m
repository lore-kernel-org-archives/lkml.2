Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2KSDuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 22:50:16 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15319 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2KSDuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 22:50:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 18 Nov 2012 19:50:14 -0800
Message-ID: <50A9AC73.1020309@nvidia.com>
Date: Mon, 19 Nov 2012 09:20:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 RESEND 0/4] mfd: tps65910: use regmap irq framework
 for interrupt
References: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com> <20121113195637.GQ27828@sortiz-mobl> <20121114012439.GF4415@opensource.wolfsonmicro.com> <20121118232342.GA18738@sortiz-mobl>
In-Reply-To: <20121118232342.GA18738@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 November 2012 04:53 AM, Samuel Ortiz wrote:
> Hi Mark,
>
> On Wed, Nov 14, 2012 at 10:24:41AM +0900, Mark Brown wrote:
>> On Tue, Nov 13, 2012 at 08:56:37PM +0100, Samuel Ortiz wrote:
>>
>>> The patchset looks fine, but it should either go through Mark's tree or I
>>> should merge Mark's regmap_irq_get_domain patch to my for-next branch.
>>> Mark, any preference ?
>> I don't mind that much, there's a tag in my regmap tree you can pull in
>> to integrate or I can apply things just as easily.
> I merged your topic/domain branch into my for-next one and I applied Laxman
> patches on top of it, thanks.

Thanks Samuel for taking care.
Just want to share info that other patch [PATCH V4 1/2] mfd: add TI 
TPS80031 mfd core driver also need ot go on same tree as this driver use 
the new api from regmap.

Thanks,
Laxman

