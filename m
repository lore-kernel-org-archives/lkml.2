Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab2HFP4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:56:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40911 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2HFP4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:56:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120806154619.GO16861@opensource.wolfsonmicro.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
	<20120806143016.GK16861@opensource.wolfsonmicro.com>
	<CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com>
	<20120806154619.GO16861@opensource.wolfsonmicro.com>
Date: Mon, 6 Aug 2012 23:56:47 +0800
Message-ID: <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 11:46 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Aug 06, 2012 at 10:42:12PM +0800, Haojian Zhuang wrote:
>> On Mon, Aug 6, 2012 at 10:30 PM, Mark Brown
>
>> > This isn't much more appropriate - _MEM is for memory ranges so isn't
>> > directly relevant to register addresses either.  If anything _IO is
>> > slightly nearer.
>
>> I use register resource to distinguish different components now. For
>> example, component driver
>> needs to access the registers in PMIC. These registers offsets are set
>> in 88pm860x-core.c.
>
> I understand this.
>
>> So I think that it may not be called _IO.
>
> Right, but _MEM isn't terribly relevant either.  If anything _IO is a
> bit better as ioports are *somewhat* similar to registers.

The problem is that each bit is already used in 32-bit IORESOURCE. I can't
find a empty bit to define the new IORESOURCE.

Regards
Haojian
