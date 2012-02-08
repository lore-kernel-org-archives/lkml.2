Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab2BHLNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:13:01 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54486 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab2BHLM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:12:59 -0500
MIME-Version: 1.0
In-Reply-To: <1328699077.20197.51.camel@cumari>
References: <1328698612-18661-1-git-send-email-coelho@ti.com>
	<20120208105957.GB16334@legolas.emea.dhcp.ti.com>
	<1328699077.20197.51.camel@cumari>
Date: Wed, 8 Feb 2012 16:42:56 +0530
Message-ID: <CAM=Q2cvZWdUk-v4-EWUJzAf4br-4+tO2s3qS_dn4KhHp+mm2+g@mail.gmail.com>
Subject: Re: [PATCH] I2C: OMAP: fix build breakage when CONFIG_OF is not set
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Luciano Coelho <coelho@ti.com>
Cc: balbi@ti.com, linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 4:34 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2012-02-08 at 12:59 +0200, Felipe Balbi wrote:
>> On Wed, Feb 08, 2012 at 12:56:52PM +0200, Luciano Coelho wrote:
>> > Since commit 6145197be6cc0583fa1a2f4ec1079d366137061e, building
>>
>> we generally like to see the commit subject here too. And adding the
>> abbreviated commit instead of the full sha1, wouldn't hurt either ;-)
>
> Ok, different practices. :)

However  there was already a discurssion.
Anyways thanks for the patch.
http://permalink.gmane.org/gmane.linux.ports.arm.omap/69796


>
> I'll send v2.
I think there was already a fix for this.

http://www.spinics.net/lists/linux-omap/msg63151.html

Anyways thanks for the patch.

>
>
>> > i2c_omap.c breaks if CONFIG_OF is not set:
>> >
>> > drivers/i2c/busses/i2c-omap.c: In function 'omap_i2c_probe':
>> > drivers/i2c/busses/i2c-omap.c:1021: error: 'omap_i2c_of_match' undeclared (first use in this function)
>> > drivers/i2c/busses/i2c-omap.c:1021: error: (Each undeclared identifier is reported only once
>> > drivers/i2c/busses/i2c-omap.c:1021: error: for each function it appears in.)
>> >
>> > This is because the definition of omap_i2c_of_match is #ifdef'd on
>> > CONFIG_OF, but the usage of it is not.
>> >
>> > Since the places where omap_ic2_of_match are prepared to get NULL
>> > pointers if CONFIG_OF is not defined, we can simply define it to NULL.
>> >
>> > Cc: Benoit Cousson <b-cousson@ti.com>
>> > Signed-off-by: Luciano Coelho <coelho@ti.com>
>>
>> after fixing the commit log, you can add:
>>
>> Reviewed-by: Felipe Balbi <balbi@ti.com>
>>
>> if you want.
>
> Thanks for your quick review!
>
> --
> Cheers,
> Luca.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
