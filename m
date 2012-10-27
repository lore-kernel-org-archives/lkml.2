Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2J0MaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:30:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60275 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2J0MaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:30:10 -0400
Message-ID: <508BD3BF.1080409@ti.com>
Date: Sat, 27 Oct 2012 17:59:51 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <olof@lixom.net>,
        <rdunlap@xenotime.net>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ARM: OMAP: ocp2scp: create omap device for ocp2scp
References: <1349675983-23803-1-git-send-email-kishon@ti.com> <1349675983-23803-4-git-send-email-kishon@ti.com> <20121026065012.GC22206@arwen.pp.htv.fi> <201210260747.11848.arnd@arndb.de> <20121026172140.GJ11908@atomide.com> <20121026195958.GB29548@arwen.pp.htv.fi> <20121026201631.GR11908@atomide.com>
In-Reply-To: <20121026201631.GR11908@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2012 01:46 AM, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [121026 13:07]:
>> On Fri, Oct 26, 2012 at 10:21:41AM -0700, Tony Lindgren wrote:
>>> * Arnd Bergmann <arnd@arndb.de> [121026 00:48]:
>>>> On Friday 26 October 2012, Felipe Balbi wrote:
>>>>>> +static void omap_init_ocp2scp(void)
>>>>>> +{
>>>>>> +     struct omap_hwmod       *oh;
>>>>>> +     struct platform_device  *pdev;
>>>>>> +     int                     bus_id = -1, dev_cnt = 0, i;
>>>>>> +     struct omap_ocp2scp_dev *ocp2scp_dev;
>>>>>> +     const char              *oh_name, *name;
>>>>>> +     struct omap_ocp2scp_platform_data *pdata;
>>>>>> +
>>>>>> +     oh_name = "ocp2scp_usb_phy";
>>>>>> +     name    = "omap-ocp2scp";
>>>>>
>>>>> how about adding checks here to return early case we're not running on
>>>>> OMAP4 or OMAP5 ??
>>>>>
>>>>
>>>> I suppose even OMAP4-only, since OMAP5 always has DT enabled.
>>>
>>> Hmm yes, currently omap_hwmod_lookup(oh_name) produces
>>> bogus errors for other omaps as the hwmod data is only
>>> there for omap4.
>>
>> shouldn't that be fixed too ? I mean, if data isn't just return -ENODEV
>> or something similar.
>
> Yes some kind of checking is needed here.

Ok. I'll fix and send.

Thanks
Kishon
