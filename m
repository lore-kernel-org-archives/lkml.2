Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2IKQKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:10:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44950 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab2IKQKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:10:50 -0400
Message-ID: <504F6249.2090501@ti.com>
Date: Tue, 11 Sep 2012 21:39:45 +0530
From: Vaibhav Hiremath <hvaibhav@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: Arnd Bergmann <arnd@arndb.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Kevin Hilman <khilman@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Jean Pihet <j-pihet@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        J Keerthy <j-keerthy@ti.com>, David Woodhouse <dwmw2@infradead.org>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [PATCH 13/16] ARM: omap: move platform_data definitions
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368559-31329-1-git-send-email-arnd@arndb.de> <CAMQu2gwLoccyjGwjjgndiW2aR--_S=UhCCTdcav6LicvYWe5SQ@mail.gmail.com> <201209111417.42879.arnd@arndb.de> <CAMQu2gz8F2FcgRuok3x1uJ4pP8=0E2-9jhYGchzU9AUtUHjYhg@mail.gmail.com>
In-Reply-To: <CAMQu2gz8F2FcgRuok3x1uJ4pP8=0E2-9jhYGchzU9AUtUHjYhg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/11/2012 7:54 PM, Shilimkar, Santosh wrote:
> On Tue, Sep 11, 2012 at 7:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 11 September 2012, Shilimkar, Santosh wrote:
>>> Just curious to know how you came with some of the above header names ?
>>>
>>> plat/mcbsp ---> dsp-mcbsp.h
>>> There is no connection of DSP with McBSP. "omap-mcbsp.h" would been a
>>> better name.
>>
>> This one was a mistake on my side, as Tony and  Peter already pointed out.
>> How about asoc-mcbsp.h or asoc-omap-mcbsp.h?
>>
> After re-reading the cover-letter and your below response,
> 'asoc-omap-mcbsp.h' seems to be fine.
> 

Note that mcbsp is also applicable to Davinci family of devices.

Thanks,
Vaibhav

>>> plat/nand.h --> /mtd-nand-omap2.h
>>> plat/onenand.h --> /mtd-onenand-omap2.h
>>> May be "omap-nand.h" and "omap-onenand.h"
>>>
>>> plat/mcspi.h-->spi-omap2-mcspi.h
>>> May be "omap-spi.h"
>>>
>>
>> As I wrote in the introductory mail, I tried to always prefix the file
>> names with the subsystem, followed by the name of the driver, in order
>> to standardize on just one set of rules.
>>
> Just read that now.
> 
>> The drivers implementing the three headers above are:
>>
>> drivers/mtd/nand/omap2.c
>> drivers/mtd/onenand/omap2.c
>> drivers/spi/spi-omap2-mcspi.c
>>
>> so these all seem appropriate.
>>
> Sorry I missed the subsystem prefix point.
> These names seems to be fine then.
> 
> Regards
> Santosh
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
