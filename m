Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3AJKRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:17:22 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60909 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3AJKRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:17:20 -0500
Message-ID: <50EE9517.3030703@ti.com>
Date: Thu, 10 Jan 2013 15:46:55 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <arnd@arndb.de>, <balbi@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: dts: omap: Add omap-usb2 dt data
References: <1348050772-27819-1-git-send-email-kishon@ti.com> <1348050772-27819-3-git-send-email-kishon@ti.com> <50EE8A89.4010801@ti.com> <50EE921D.8020601@ti.com>
In-Reply-To: <50EE921D.8020601@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 10 January 2013 03:34 PM, Benoit Cousson wrote:
> On 01/10/2013 10:31 AM, kishon wrote:
>> Hi Benoit,
>>
>> On Wednesday 19 September 2012 04:02 PM, Kishon Vijay Abraham I wrote:
>>> Add omap-usb2 data node in omap4 device tree file. Since omap-usb2 is
>>> connected to ocp2scp, omap-usb2 dt data is added as a child node
>>> of ocp2scp.
>>>
>>> Acked-by: Felipe Balbi <balbi@ti.com>
>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>
>> This patch is also missing in mainline :-(
>
> Well, in that case this was done on purpose :-)
>
>>
>> Thanks
>> Kishon
>>
>>> ---
>>>    arch/arm/boot/dts/omap4.dtsi |    5 +++++
>>>    1 file changed, 5 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
>>> index 4fbb9dc..28eaddc 100644
>>> --- a/arch/arm/boot/dts/omap4.dtsi
>>> +++ b/arch/arm/boot/dts/omap4.dtsi
>>> @@ -303,6 +303,11 @@
>>>                #size-cells = <1>;
>>>                ranges;
>>>                ti,hwmods = "ocp2scp_usb_phy";
>>> +            usb2phy@4a0ad080 {
>>> +                compatible = "ti,omap-usb2";
>>> +                reg = <0x4a0ad080 0x58>,
>>> +                      <0x4a002300 0x4>; /* TO BE REMOVED: SCM */
>
> Rob and I did not agree to use that temp hack in the case of DT, so you
> were supposed to repost with a proper driver for the SCM part that
> control the USB.

Ok. Missed that. Will work on that.

Thanks
Kishon
