Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2DWLTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:19:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44240 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2DWLTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:19:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120423091733.GJ24211@n2100.arm.linux.org.uk>
References: <1335172482-27648-1-git-send-email-linus.walleij@stericsson.com>
	<20120423091733.GJ24211@n2100.arm.linux.org.uk>
Date: Mon, 23 Apr 2012 13:19:07 +0200
Message-ID: <CACRpkdaBePuSE555c5iN9uF9no+2zHDSYp=sMMmevC9ei6R+kA@mail.gmail.com>
Subject: Re: [PATCH 5/9] gpio/nomadik: use typesafe __io_address()
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 11:17 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Apr 23, 2012 at 11:14:42AM +0200, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> We were using a custom io_p2v() (physical-to-virtual) translation
>> macro, but with the advent of the cross-platform __io_address()
>> let us try to get rid of this. Inspired by a similar patch by
>> Jonas Aberg.
>
> Is there any point to io_p2v() or __io_address() anymore?  Won't ioremap()
> do here?

Hey it works, I'll delete the static maps as well and send an updated patch.

Thanks Russell,
Linus Walleij
