Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1HVM3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 08:29:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35792 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1HVM3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 08:29:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110819165252.GC4016@kroah.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
	<20110819104816.GA5030@pulham.picochip.com>
	<CACRpkdZhg_1WM37uqT1PNmpUjWS_groWJmNnR4SBjqJ6LFQQWQ@mail.gmail.com>
	<201108191636.29161.arnd@arndb.de>
	<20110819165252.GC4016@kroah.com>
Date: Mon, 22 Aug 2011 14:29:48 +0200
Message-ID: <CACRpkdaS6KiZGxSOE=T4ErXAPoWoYWYWFNVancWjQV1L4SCAew@mail.gmail.com>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jamie Iles <jamie@jamieiles.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 6:52 PM, Greg KH <greg@kroah.com> wrote:

>> IIRC Greg would prefer now to never have had the distinction
>> and wants to make all future uses use a bus_type.
>
> Yes, that is totally correct.  Kay has also written much more about this
> and why this is the way forward many times in the past, see lkml
> archives for the details if anyone is interested.

Nah I trust you, I will switch it to use bus_type instead no problem.

Thanks!
Linus Walleij
