Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2JBCb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:31:59 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48024 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2JBCZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:25:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120928232858.GT30928@sortiz-mobl>
References: <1348222014-15927-1-git-send-email-haojian.zhuang@gmail.com>
	<1348222014-15927-2-git-send-email-haojian.zhuang@gmail.com>
	<20120928232858.GT30928@sortiz-mobl>
Date: Tue, 2 Oct 2012 10:25:06 +0800
Message-ID: <CAN1soZyAB3w=TQndi3ZcETFMp8QtZJJKcy0KbbLhg6hQ1Fu4Uw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mfd: 88pm860x: use irqdomain
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 7:28 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Haojian:
>
> On Fri, Sep 21, 2012 at 06:06:51PM +0800, Haojian Zhuang wrote:
>> @@ -593,13 +610,9 @@ static int __devinit device_irq_init(struct pm860x_chip *chip,
>>                               : chip->companion;
>>       unsigned char status_buf[INT_STATUS_NUM];
>>       unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
>> -     int i, data, mask, ret = -EINVAL;
> That one breaks the build:
>
> drivers/mfd/88pm860x-core.c: In function ‘device_irq_init’:
> drivers/mfd/88pm860x-core.c:628:7: error: ‘i’ undeclared (first use in this
> function)
> drivers/mfd/88pm860x-core.c:628:7: note: each undeclared identifier is
> reported only once for each function it appears in
> drivers/mfd/88pm860x-core.c:629:3: error: ‘__irq’ undeclared (first use in
> this function)
> make[2]: *** [drivers/mfd/88pm860x-core.o] Error 1
>
> I removed this patchset until it builds...
>
I'm sorry for inconvenience. Now fix it.

Regards
Haojian
