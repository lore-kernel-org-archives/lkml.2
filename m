Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1GMXeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:34:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48821 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1GMXeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:34:02 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049E834757@HQMAIL01.nvidia.com>
References: <1309897306-22953-1-git-send-email-swarren@nvidia.com>
 <20110706053941.GE9978@ponder.secretlab.ca> <74CDBE0F657A3D45AFBB94109FB122FF049E834757@HQMAIL01.nvidia.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 14 Jul 2011 08:33:38 +0900
X-Google-Sender-Auth: O1wdoEs3AG4RrHi-iUxPIQhpEkE
Message-ID: <CACxGe6tojgLSmHTxzGn3hZZVqiR_z6xbWrazYekm0TwQoWK5eA@mail.gmail.com>
Subject: Re: [PATCH] i2c: tegra: Use engineering names in DT compatible property
To: Stephen Warren <swarren@nvidia.com>
Cc: "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 2:59 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Grant Likely wrote at Tuesday, July 05, 2011 11:40 PM:
>> On Tue, Jul 05, 2011 at 02:21:46PM -0600, Stephen Warren wrote:
>> > Engineering names are more stable than marketing names. Hence, use them
>> > for Device Tree compatible properties instead.
>> >
>> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> > ---
>> > Grant, this is against devicetree/arm and also makes sense for
>> > devicetree/test.
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>>
>> Ben is the one to pick up this patch.
>
> I don't believe anyone ever sent a patch to Ben to add tegra_i2c_of_match
> to the driver; the OF support patch didn't include that part of the code.
> As such, Ben can't yet apply this to his tree. (Although I note this patch
> is in Grant's /arm and /test trees, which is probably good enough for now).

Hmmm, I thought it had been done.  It certainly is ready to go in.  Do
you want to put together a roll-up patch that includes all the
required changes and post it again? (although double check linux-next
first).

g.

>
>> >  drivers/i2c/busses/i2c-tegra.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
>> > index 8914bd1..99b1b6d 100644
>> > --- a/drivers/i2c/busses/i2c-tegra.c
>> > +++ b/drivers/i2c/busses/i2c-tegra.c
>> > @@ -716,7 +716,7 @@ static int tegra_i2c_resume(struct platform_device *pdev)
>> >  #if defined(CONFIG_OF)
>> >  /* Match table for of_platform binding */
>> >  static const struct of_device_id tegra_i2c_of_match[] __devinitconst = {
>> > -   { .compatible = "nvidia,tegra250-i2c", },
>> > +   { .compatible = "nvidia,tegra20-i2c", },
>> >     {},
>> >  };
>> >  MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
>> > --
>> > 1.7.0.4
>> >
>
> --
> nvpublic
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
