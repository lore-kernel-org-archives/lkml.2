Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1HWOWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:22:48 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43193 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1HWOWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:22:44 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYJK7yJrocEJYudeOW0JbcWMTiqrhz1-mNZO0jc0y3S6g@mail.gmail.com>
References: <1307616640-2013-1-git-send-email-mattias.wallin@stericsson.com>
	<CACRpkdYJK7yJrocEJYudeOW0JbcWMTiqrhz1-mNZO0jc0y3S6g@mail.gmail.com>
Date: Tue, 23 Aug 2011 16:22:43 +0200
Message-ID: <CACRpkdYkjqFp0cxpLBLQVN-qPtugjfo1rsrXqsh8f7wThB544g@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: ab5500 chip register access
From: Linus Walleij <linus.walleij@linaro.org>
To: Mattias Wallin <mattias.wallin@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 12:02 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Jun 9, 2011 at 12:50 PM, Mattias Wallin
> <mattias.wallin@stericsson.com> wrote:
>
>> The analog baseband chip ab5500 is a multi functional chip
>> containing regulators, charging, gpio, USB and accessory detect.
>> It also contain various multimedia functionalities like digital
>> encoder and audio codec.
>> The core driver added with this patch provides register access via
>> i2c via PRCMU. Event handling implemented as irq_chip will come in
>> future patches since it depends on PRCMU functionality not yet
>> implemented.
>>
>> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Sam, what happened to these two patches? Something that needs
> to  be fixed about them?

Ping on this...

Thanks!
Linus Walleij
