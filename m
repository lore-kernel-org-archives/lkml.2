Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2ITF5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 01:57:04 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:49387 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab2ITF5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 01:57:01 -0400
MIME-Version: 1.0
In-Reply-To: <201209191857.57862.arnd@arndb.de>
References: <1347614434-15938-1-git-send-email-santosh.shilimkar@ti.com>
 <20120917215128.GF11762@atomide.com> <201209191857.57862.arnd@arndb.de>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 20 Sep 2012 11:26:39 +0530
Message-ID: <CAMQu2gw0AmVhW+qR9GUGkUd2G+aZd9A=skTUDJiY2BMpURmSNQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers: bus: Move the OMAP interconnect driver to drivers/bus/
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 12:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
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
> It turns out that the patch actually did conflict and we now have a broken
> omap2plus_defconfig. The patch below seems to fix it, but please verify
> that this makes sense.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
Looks correct.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
