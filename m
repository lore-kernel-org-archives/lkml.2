Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab2IPWqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 18:46:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62800 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2IPWqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 18:46:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120916223541.GA26353@n2100.arm.linux.org.uk>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
	<1347658492-11608-7-git-send-email-arnd@arndb.de>
	<CACRpkdYsv7LJj=aJj3y-GhpAMD8PTKdLsYO8KATWevMM4F5MaQ@mail.gmail.com>
	<20120916223541.GA26353@n2100.arm.linux.org.uk>
Date: Mon, 17 Sep 2012 00:46:21 +0200
Message-ID: <CACRpkdbR+eOTkHHqQqJMSfui=Zn1vgehtXiJax-h5MkN6yK=tQ@mail.gmail.com>
Subject: Re: [PATCH 06/24] ARM: integrator: use __iomem pointers for MMIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nico@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 12:35 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Sep 17, 2012 at 12:19:11AM +0200, Linus Walleij wrote:
>>
>> However if Russell applies some of the stuff that is pending
>> in his tracker (was pending uncertain acceptance of
>> CONFIG_ATAGS, which is merged now) this will likely
>> conflict.
>
> I'm actually a little confused... 7514/1 apparantly has a comment from
> me on it, but I don't remember making any comments against it - and the
> comment is definitely crap for the patch.  I certainly wasn't processing
> patches at 20:38 on Friday 7th, so, I'm wondering what's going on there.

I'm as confused as you are :-(

On some of the other patches I added a changelog, but this
one doesn't have one, and I don't remember seeing that comment
until now.

Do you want me to resubmit it as 7514/2?

Yours,
Linus Walleij
