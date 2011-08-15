Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1HOJfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 05:35:53 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42921 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1HOJfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 05:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110815091245.GC32705@game.jcrosoft.org>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
 <1313377893.14434.5.camel@Lily> <CAMPhdO8rkct4H74zXBzaDa183u5vrPArerXgiNXwvQWzZT67Ng@mail.gmail.com>
 <20110815091245.GC32705@game.jcrosoft.org>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 15 Aug 2011 17:35:31 +0800
Message-ID: <CAMPhdO_StSa9fsYLNjJDd0KDkUyg6ep3gN2n5Gx-WmZ8t=bTFw@mail.gmail.com>
Subject: Re: [PATCH V4 0/3] ARM: mmp: add audio sram support
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Leo Yan <leoy@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <hzhuang1@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 5:12 PM, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> On 16:43 Mon 15 Aug     , Eric Miao wrote:
>> On Mon, Aug 15, 2011 at 11:11 AM, Haojian Zhuang
>> <haojian.zhuang@marvell.com> wrote:
>> > On Sun, 2011-08-14 at 20:09 -0700, Leo Yan wrote:
>> >> On mmp platform, there have two sram banks:
>> >> audio sram bank, and internal sram bank for video and PM.
>> >> So add the sram module to manage these sram banks.
>> >>
>> >> And register the sram banks so can dynamically alloc/free
>> >> the buffer.
>> >>
>> >> Leo Yan (3):
>> >>   ARM: mmp: add sram allocator
>> >>   ARM: mmp: register audio sram bank
>> >>   ARM: mmp: register internal sram bank
>> >>
>> >>  arch/arm/Kconfig                      |    1 +
>> >>  arch/arm/mach-mmp/Makefile            |    2 +-
>> >>  arch/arm/mach-mmp/brownstone.c        |   11 ++
>> >>  arch/arm/mach-mmp/include/mach/mmp2.h |   13 +++
>> >>  arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
>> >>  arch/arm/mach-mmp/mmp2.c              |    3 +
>> >>  arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
>> >>  7 files changed, 232 insertions(+), 1 deletions(-)
>> >>  create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
>> >>  create mode 100644 arch/arm/mach-mmp/sram.c
>> >>
>> > Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
>>
>> Looks good to me. Thanks Haojian. Applied to -devel.
> I've some reserve on the named pool they need to be managed at generic level
> not here

What are their names? And your suggestions to fix this?

>
> Best Regards,
> J.
>
