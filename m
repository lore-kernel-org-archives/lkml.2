Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2KXXVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 18:21:51 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55848 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2KXXVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 18:21:50 -0500
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:5cc0:68d9:6000:d87c]
In-Reply-To: <2676657.zDjyfqIDdm@vostro.rjw.lan>
References: <1352330622-13616-1-git-send-email-robherring2@gmail.com>
	<201211122200.07901.arnd@arndb.de>
	<2676657.zDjyfqIDdm@vostro.rjw.lan>
Date: Sat, 24 Nov 2012 15:21:49 -0800
Message-ID: <CAOesGMgUsmjZCpMN8WpYk2LpYpfxp-wyCwajw4TikgU8ve2g0A@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: add Calxeda SOC idle support
From: Olof Johansson <olof@lixom.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robherring2@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Sat, Nov 24, 2012 at 2:03 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, November 12, 2012 10:00:07 PM Arnd Bergmann wrote:
>> On Wednesday 07 November 2012, Rob Herring wrote:
>> > From: Rob Herring <rob.herring@calxeda.com>
>> >
>> > Add support for core powergating on Calxeda platforms. Initially, this
>> > supports ECX-1000 (highbank), but support will be added for ECX-2000
>> > later.
>> >
>> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> > Cc: Len Brown <len.brown@intel.com>
>> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>
>> > It's not really clear where we want ARM cpuidle drivers. We're moving
>> > everything else out of arch/arm, and my understanding is Len doesn't want
>> > them in drivers/idle. It seems kind of silly to me to have the framework
>> > and drivers in 2 places. I've put this in drivers/cpuidle, but it doesn't
>> > make any difference to me.
>>
>> Fine with me. I just don't want in in arch/arm because I'm guessing this will
>> be shared with arm64, which in turn shares idle (and other) drivers with various
>> powerpc, mips and x86 socs.
>
> Applied to linux-pm.git/linux-next as v3.8 material.

We already have it in arm-soc. Since there's no maintainer listed for
the directory, it didn't seem like there were any better merge paths.



-Olof
