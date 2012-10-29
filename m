Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab2J2GYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:24:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45445 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2J2GYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:24:16 -0400
Message-ID: <508E20FC.2080107@ti.com>
Date: Mon, 29 Oct 2012 11:53:56 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <arnd@arndb.de>, <olof@lixom.net>,
        <rdunlap@xenotime.net>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] drivers: bus: ocp2scp: add pdata support
References: <1349675983-23803-1-git-send-email-kishon@ti.com> <1349675983-23803-2-git-send-email-kishon@ti.com> <20121016165043.GS15569@atomide.com> <20121025004806.GK11928@atomide.com> <20121025061722.GB4449@arwen.pp.htv.fi> <20121025174446.GT11928@atomide.com> <20121026064736.GA22206@arwen.pp.htv.fi> <20121026171655.GI11908@atomide.com> <20121026195915.GA29548@arwen.pp.htv.fi> <508BD344.1090001@ti.com> <20121029061026.GO17570@arwen.pp.htv.fi>
In-Reply-To: <20121029061026.GO17570@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 29 October 2012 11:40 AM, Felipe Balbi wrote:
> Hi,
>
> On Sat, Oct 27, 2012 at 05:57:48PM +0530, kishon wrote:
>> Hi,
>>
>> On Saturday 27 October 2012 01:29 AM, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Fri, Oct 26, 2012 at 10:16:55AM -0700, Tony Lindgren wrote:
>>>> * Felipe Balbi <balbi@ti.com> [121025 23:55]:
>>>>> On Thu, Oct 25, 2012 at 10:44:47AM -0700, Tony Lindgren wrote:
>>>>>> * Felipe Balbi <balbi@ti.com> [121024 23:24]:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On Wed, Oct 24, 2012 at 05:48:07PM -0700, Tony Lindgren wrote:
>>>>>>>> * Tony Lindgren <tony@atomide.com> [121016 09:53]:
>>>>>>>>> * Kishon Vijay Abraham I <kishon@ti.com> [121007 23:01]:
>>>>>>>>>> ocp2scp was not having pdata support which makes *musb* fail for non-dt
>>>>>>>>>> boot in OMAP platform. The pdata will have information about the devices
>>>>>>>>>> that is connected to ocp2scp. ocp2scp driver will now make use of this
>>>>>>>>>> information to create the devices that is attached to ocp2scp.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>>>>>>>
>>>>>>>>> This fixes the regression on my panda es for musb port:
>>>>>>>>>
>>>>>>>>> Acked-by: Tony Lindgren <tony@atomide.com>
>>>>>>>>
>>>>>>>> Looks like nobody has picked this one up and we need it to
>>>>>>>> fix the musb regression on omap, so I'll queue these up.
>>>>>>>
>>>>>>> I don't seem to have the patches around in any mailbox :-(
>>>>>>
>>>>>> Bounced them to you. Do you have any better ideas for the
>>>>>> -rc cycle to fix the MUSB regression on omap4?
>>>>>
>>>>> Well, there are two regressions that I know of. One is caused by the
>>>>> mode1 DMA changes, which I'll just revert, and the other is the
>>>>> missing platform_data support on the new PHY driver which these patches
>>>>> are supposed to solve, right ?
>>>>
>>>> Yes that's it AFAIK.
>>>
>>> Kishon, any other patches I need to take to get MUSB working on v3.7 ?
>>
>> These should be good enough to get MUSB working..
>
> nothing needed for omap-usb2.c ? That's great, cheers

No. Nothing of pdata sort is used in omap-usb2.c

Thanks
Kishon
