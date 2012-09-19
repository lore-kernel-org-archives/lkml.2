Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab2ISQVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:21:37 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:46401 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932126Ab2ISQVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:21:35 -0400
MIME-Version: 1.0
In-Reply-To: <201209191458.00531.arnd@arndb.de>
References: <1347614434-15938-1-git-send-email-santosh.shilimkar@ti.com>
 <20120917215128.GF11762@atomide.com> <201209191458.00531.arnd@arndb.de>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 19 Sep 2012 21:51:13 +0530
Message-ID: <CAMQu2gyyROhnhhuD8pBviPojEr+4JJuK1hE_fg=6jOEX9Wd7Cg@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers: bus: Move the OMAP interconnect driver to drivers/bus/
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 8:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
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
Thanks Arnd. Sorry I missed to Cc Olof on the patch. Will take care of
this in future.

Regards
santosh
