Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2K3G7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 01:59:00 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:38914 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2K3G67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 01:58:59 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20121129200708.GN19440@n2100.arm.linux.org.uk>
References: <201211291424.25711.arnd@arndb.de>
	<20121129200708.GN19440@n2100.arm.linux.org.uk>
Date: Thu, 29 Nov 2012 22:58:58 -0800
Message-ID: <CAOesGMgzA_mtVSvoktEj+TwRu=hU6dRN9xO+uYTXN0iKH9j2_Q@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: final SoC fixes for 3.7
From: Olof Johansson <olof@lixom.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "arm@kernel.org" <arm@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 12:07 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Nov 29, 2012 at 02:24:25PM +0000, Arnd Bergmann wrote:
>> Hi Linus,
>>
>> These should be the last bug fixes you get from Olof and me for 3.7.
>> This is based on the previous one you pulled and there is nothing
>> spectacular in here. I'll follow up with a second pull request
>> knowing that those are probably too late now, but I'd like to let
>> you know about the ones that didn't make it and give you the chance
>> to pull those anyway if you prefer.
>
> I don't see anything in here for the OMAP warning that I've been reporting
> for the last two weeks.  What's going on with getting fixes merged into
> arm-soc?

I've merged it in now (for 3.8) -- the pull request from Tony had been
pending for a couple of days. Should mirror out shortly.


-Olof
