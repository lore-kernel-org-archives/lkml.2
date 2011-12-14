Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab1LNW0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:26:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46801 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207Ab1LNW0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:26:37 -0500
MIME-Version: 1.0
In-Reply-To: <20111214222232.GA3125@gallagher>
References: <1323896156-20692-1-git-send-email-linus.walleij@stericsson.com>
	<4EE91FDD.5070206@gmail.com>
	<20111214222232.GA3125@gallagher>
Date: Wed, 14 Dec 2011 23:26:37 +0100
Message-ID: <CACRpkdZd2kjsYWadCn9Mb9B9jBWm8oH-2Jk5+YeBKb+nMW9x+g@mail.gmail.com>
Subject: Re: [PATCH] irq: fix crash due to op-less irq domains
From: Linus Walleij <linus.walleij@linaro.org>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:22 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> On Wed, Dec 14, 2011 at 04:14:53PM -0600, Rob Herring wrote:
>>
>> I believe this is going in with some iMX changes. But I guess the VIC is
>> going to need a fix to use irq_domain_simple_ops.
>
> Yes, Thomas has acked that patch, but it wasn't clear who was going to
> merge it.  I asked if this could go through Russell along with a patch
> to make the VIC driver use it but haven't heard anything back yet.  I'll
> repost them now.

Can you please repost, then put them in Russell's patch tracker?

Would be super!
Thanks,
Linus Walleij
