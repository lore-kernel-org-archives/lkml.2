Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2IZX1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 19:27:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41050 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2IZX1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 19:27:46 -0400
Message-ID: <50638F5D.8070508@ti.com>
Date: Wed, 26 Sep 2012 16:27:25 -0700
From: "Cousson, Benoit" <b-cousson@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.luna@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] OMAP: mailbox initial device tree support
References: <1347494898-16671-1-git-send-email-omar.luna@linaro.org> <1347494898-16671-4-git-send-email-omar.luna@linaro.org> <CALLhW=4d8zxekkeGr1S52aGbufyk-vGeE9REYhDSt8pnap_Dxw@mail.gmail.com>
In-Reply-To: <CALLhW=4d8zxekkeGr1S52aGbufyk-vGeE9REYhDSt8pnap_Dxw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Omar,

On 9/26/2012 3:21 PM, Omar Ramirez Luna wrote:
> Hi Benoit,
>
> On 12 September 2012 19:08, Omar Ramirez Luna <omar.luna@linaro.org> wrote:
>> To allow mailbox driver to function with device tree.
>>
>> Tested in OMAP4 and OMAP3. OMAP2 untested.
>>
>> Patch: arm/dts: OMAP2+: Add mailbox nodes, was Acked by Benoit
>> however it seems it wasn't picked up, so resend.
>>
>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg69121.html
>>
>> Patch: OMAP: mailbox: add device tree support, there wasn't an
>> opposition other than to cleanup the driver too, however I got
>> quite some patches to send before continuing the cleanup.
>>
>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg69338.html
>>
>> Omar Ramirez Luna (2):
>>    OMAP: mailbox: add device tree support
>>    arm/dts: OMAP2+: Add mailbox nodes
>>
>>   .../devicetree/bindings/arm/omap/mailbox.txt       |    9 +++++++++
>>   arch/arm/boot/dts/omap2.dtsi                       |    5 +++++
>>   arch/arm/boot/dts/omap3.dtsi                       |    5 +++++
>>   arch/arm/boot/dts/omap4.dtsi                       |    5 +++++
>>   arch/arm/mach-omap2/devices.c                      |    3 +++
>>   arch/arm/mach-omap2/mailbox.c                      |   12 ++++++++++++
>>   6 files changed, 39 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/arm/omap/mailbox.txt
>
> Ping. I'm in the understanding that these go through your tree, am I right?

Since it is too late for 3.7, you should probably do two more things:
- move the mailbox driver outside mach-omap2
- move the nr_mbox information in the driver as well instead of the 
hwmod for the DT boot.


Regards,
Benoit

