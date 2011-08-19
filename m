Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1HSNE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:04:29 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:3761 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab1HSNE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:04:28 -0400
Message-ID: <4E4E5F52.7070605@atmel.com>
Date: Fri, 19 Aug 2011 15:04:18 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.20) Gecko/20110804 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] dmaengine: at_hdmac fixes for next
References: <4E4A7713.1070902@atmel.com> <1313758426.2336.2.camel@vkoul-udesk3>
In-Reply-To: <1313758426.2336.2.camel@vkoul-udesk3>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 19/08/2011 14:53, Koul, Vinod :
> On Tue, 2011-08-16 at 15:56 +0200, Nicolas Ferre wrote:
>> Vinod,
>>
>> Please pull from:
>>
>>   git://github.com/at91linux/linux-2.6-at91.git nfe/sdma_at_hdmac
>>
>> to receive latest updates for the Atmel at_hdmac dmaengine driver. Those changes are made on top of current linus' git tree (v3.1-rc2-59-g5bad33c).
>> The patches below have been discussed on the linux-arm-kernel mailing-list.
>>
>> Thanks,
>>
>> Nicolas Ferre (4):
>>       dmaengine: at_hdmac: replace spin_lock* with irqsave variants
>>       dmaengine: at_hdmac: improve power management routines
>>       dmaengine: at_hdmac: add wrappers for testing channel state
>>       dmaengine: at_hdmac: fix way to specify cyclic capability
>>
>>  drivers/dma/at_hdmac.c      |  159 +++++++++++++++++++++++++++++++++---------
>>  drivers/dma/at_hdmac_regs.h |   24 +++++++
>>  2 files changed, 149 insertions(+), 34 deletions(-)
>>
> Hi Nicolas,
> 
> I tried to merge your branch, but I also get lot on unwanted commits :(
> Looks like this branch is based on current Linus's tree, I typically
> base my next on rc-X and not any random commit.

Yes, I am sorry for that and realize that it can be a mess for you... I
will take the habit to cling to a -rcX for my pull requests.

> Either you can rebase to latest rc-X and I will merge, or since I
> created a test branch I can extract your 4 patches and apply to my next.

If you have a test branch close at hand you can extract my patches.
Thanks for your help.

Best regards,
-- 
Nicolas Ferre

