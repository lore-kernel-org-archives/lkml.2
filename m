Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2ISPKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:10:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41861 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2ISPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:10:44 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:24c8:79b5:efe7:d61c]
In-Reply-To: <201209191458.00531.arnd@arndb.de>
References: <1347614434-15938-1-git-send-email-santosh.shilimkar@ti.com>
	<20120917215128.GF11762@atomide.com>
	<201209191458.00531.arnd@arndb.de>
Date: Wed, 19 Sep 2012 08:10:43 -0700
Message-ID: <CAOesGMgHr4pnqerTm=bL8K5cwYxX6Ry9waEOc4H4y3xBzCFkMQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers: bus: Move the OMAP interconnect driver to drivers/bus/
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 7:58 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 17 September 2012, Tony Lindgren wrote:
>> * Santosh Shilimkar <santosh.shilimkar@ti.com> [120914 02:21]:
>> > OMAP interconnect drivers are used for the interconnect error handling.
>> > Since they are bus driver, lets move it to newly created drivers/bus.
>> >
>> > Cc: Arnd Bergmann <arnd@arndb.de>
>> > Cc: Tony Lindgren <tony@atomide.com>
>> > Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
>> > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> > ---
>> > Patch just moves OMAP interconnect drivers as is to the newly created
>> > driver/bus/* directory. Patch is generated against "arm-soc/drivers/ocp2scp"
>> > tree and test on all OMAP boards.
>>
>> Great, looks like this should not conflict with other
>> omap patches queued, so Arnd should probably take this into
>> the bus branch:
>>
>> Acked-by: Tony Lindgren <tony@atomide.com>
>
> Ok, added to the branch. In the future please Cc both Olof and me when submitting
> patches for inclusion.
>
> Olof: I figured it would be easier if I just add this one than relaying it to
> you.

Sounds good, thanks for the heads up.


-Olof
