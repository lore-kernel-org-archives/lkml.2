Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab2EIO1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:27:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45558 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863Ab2EIO1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:27:54 -0400
MIME-Version: 1.0
In-Reply-To: <4FA9F16D.9090106@samsung.com>
References: <4FA9F16D.9090106@samsung.com>
Date: Wed, 9 May 2012 22:27:52 +0800
Message-ID: <CAJuYYwRDe_KyXnPxZq_fGyHuYAB=e76AaRZwoe9UjUer=QX3YA@mail.gmail.com>
Subject: Re: I have question for supporting irq_domain of MAX8997
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Choi,

On 9 May 2012 12:24, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> Dear Thomas,
>
> I have a question about your following patch:
> - https://lkml.org/lkml/2012/4/18/145
>
> I am implementing extcon-max8997 device driver which support MUIC feature
> of Maxim MAX8997 chip. It have irq handler for MUIC irq based on
> irq_base in struct max8997_dev. I have plan to support irq_domain for
> MAX8997 instead of previous
> irq operation and will modify that extcon-max8997 use irq_domain method.
>
> So, Do you have plan to support irq domain for MAX8997 irq?
> If yes, I will implement other tasks to support irq_domain for Maxim
> MAX77686.

The irq domain support for max8997 irq is already posted. I am yet to
address some of the review comments for those patches and hence the
max8997 dt (+ irqdomain) patches are still work in progress. But the
irq domain support for max8997 is complete.

Thanks,
Thomas.

>
> Thank you,
>
> Best Regards,
> Chanwoo Choi
