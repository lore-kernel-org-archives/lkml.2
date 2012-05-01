Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2EAWSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 18:18:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61572 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2EAWSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 18:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120501113130.GE20224@sortiz-mobl>
References: <1334647849-1773-1-git-send-email-linus.walleij@stericsson.com>
	<20120501113130.GE20224@sortiz-mobl>
Date: Wed, 2 May 2012 00:18:45 +0200
Message-ID: <CACRpkdYec+g8CDrkK1kn6ThQ4a=K9Qye_zbZPgXAei0pDA9Wbw@mail.gmail.com>
Subject: Re: [PATCH 5/6] mfd/ab8500: support of hierachical interrupt
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Maxime Coquelin <maxime.coquelin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 1:31 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:

> On Tue, Apr 17, 2012 at 09:30:49AM +0200, Linus Walleij wrote:
>> +static irqreturn_t ab8500_hierarchical_irq(int irq, void *dev)
>> +{

>> +     /*  Hierarchical interrupt version */
>> +     for (i = 0; i < AB8500_IT_LATCHHIER_NUM; i++) {
>> +             do {
>> +                     int latch_bit = __ffs(hier_val);
>> +                     do {
>> +                             int int_bit = __ffs(latch_val);
>> +                     } while (latch_val);
>> +             } while (hier_val);
>> +     }
>> +     return IRQ_HANDLED;
>> +}
>
> With 4 nested loops, this one is getting difficult to read. Have you
> considered splitting the loops into separate routines ?

I get the point :-D

Michel do you think this can be done?

Yours,
Linus Walleij
