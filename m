Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0JUKGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:06:14 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:34667 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0JUKGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:06:13 -0400
Message-ID: <4CC01075.8000401@atmel.com>
Date: Thu, 21 Oct 2010 12:05:41 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Peter Horton <phorton@bitbox.co.uk>, pgsellmann@portner-elektronik.at
Subject: Re: [GITT PULL] AT91: second pull for 2.6.37 merge window
References: <4CBECD42.7070905@atmel.com> <20101020191125.GA22100@n2100.arm.linux.org.uk>
In-Reply-To: <20101020191125.GA22100@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 20/10/2010 21:11, Russell King - ARM Linux :
> Did you miss this?
> 
> | Tuesday evening my time (BST, so UTC+1h) is the last time I'm merging
> | anything into my git tree.
> | 
> | With the upcoming change to the debug macro infrastructure, there are
> | two options for people who have new board support code external to my
> | tree:
> | 
> | 1. Send me a pull request (based on Linus' tree not mine) by Tuesday.
> | 
> | 2. Eat merge conflicts and build breakage for breakfast when my tree
> |    merges into mainline.  ;)
> | 
> | No further complaints about this please - there's been plenty of warning
> | about these debug macro changes.

Well, no. I had chosen the second option - and I am quite confident with
breakage as I think I have anticipated them...

So, will you do another pull round during Linus' merge window? Reading
your answer I suspect that you will not ;-)

If not I will then directly send the pull request to Linus.

Thanks, bye,

> On Wed, Oct 20, 2010 at 01:06:42PM +0200, Nicolas Ferre wrote:
>> Hi Russell,
>>
>> Could you please pull the following:
>>
>>   git://github.com/at91linux/linux-2.6-at91.git for_rmk_bis
>>
>> This contains second set of AT91 update for 2.6.37 
>> merge window. All has been discussed on the list. 
>> It is based on latest linus' git tree:
>> commit 51ea8a88aae425915b458bfe295f1f10a3d52781
>>
>> Nicolas Ferre (3):
>>       AT91: trivial: align comment of at91sam9g20_reset with one more tab
>>       AT91: reset routine cleanup, remove not needed icache flush
>>       AT91: reset: extend alternate reset procedure to several chips
>>
>> Peter Gsellmann (1):
>>       AT91: add board support for Pcontrol_G20
>>
>> Peter Horton (1):
>>       AT91: Fix AT91SAM9G20 reset as per the errata in the data sheet
>>
>>  arch/arm/configs/pcontrol_g20_defconfig |  175 +++++++++++++++++
>>  arch/arm/mach-at91/Kconfig              |    6 +
>>  arch/arm/mach-at91/Makefile             |   13 +-
>>  arch/arm/mach-at91/at91sam9260.c        |    7 +-
>>  arch/arm/mach-at91/at91sam9261.c        |    7 +-
>>  arch/arm/mach-at91/at91sam9263.c        |    7 +-
>>  arch/arm/mach-at91/at91sam9_alt_reset.S |   48 +++++
>>  arch/arm/mach-at91/at91sam9rl.c         |    7 +-
>>  arch/arm/mach-at91/board-pcontrol-g20.c |  322 +++++++++++++++++++++++++++++++
>>  arch/arm/mach-at91/generic.h            |    3 +
>>  10 files changed, 565 insertions(+), 30 deletions(-)
>>  create mode 100644 arch/arm/configs/pcontrol_g20_defconfig
>>  create mode 100644 arch/arm/mach-at91/at91sam9_alt_reset.S
>>  create mode 100644 arch/arm/mach-at91/board-pcontrol-g20.c
>>
>> Thanks a lot, best regards,
>> -- 
>> Nicolas Ferre
>>
-- 
Nicolas Ferre

