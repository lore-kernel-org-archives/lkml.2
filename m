Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1HSFiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 01:38:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50199 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1HSFiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 01:38:24 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20110819005900.GA32368@sirena.org.uk>
References: <1313653056-27263-1-git-send-email-myungjoo.ham@samsung.com>
	<1313653056-27263-3-git-send-email-myungjoo.ham@samsung.com>
	<20110819005900.GA32368@sirena.org.uk>
Date: Fri, 19 Aug 2011 14:38:22 +0900
X-Google-Sender-Auth: xaC2R6-BkBG3OtwxTVKRg3IibLQ
Message-ID: <CAJ0PZbSSQ3i-J6gq-d+UQrYJiJCsa5mV9TzFzPgD9=JnvuM5NA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] MFD: MAX8997: Support Wake-up from Suspend
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        kyungmin.park@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 9:59 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Aug 18, 2011 at 04:37:36PM +0900, MyungJoo Ham wrote:
>
>> +     if (max8997->wakeup && max8997->irq)
>> +             irq_set_irq_wake(max8997->irq, 1);
>
> There's supposed to be userspace control of this stuff (see
> device_may_wake_up() and friends) though that can always be added in a
> second pass).
>

Ok, I'm resubmitting this part of the patchset. Thanks.



Cheers.

MyungJoo

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
