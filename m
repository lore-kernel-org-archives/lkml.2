Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2J3FZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 01:25:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51919 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab2J3FZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 01:25:37 -0400
Message-ID: <508F64EC.9000809@ti.com>
Date: Tue, 30 Oct 2012 10:56:04 +0530
From: Sourav <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [RESEND/PATCHv3] arm: dts: omap5-evm: Add keypad support
References: <1351507226-10328-1-git-send-email-sourav.poddar@ti.com> <508EB250.20607@ti.com>
In-Reply-To: <508EB250.20607@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,
On Monday 29 October 2012 10:14 PM, Benoit Cousson wrote:
> Hi Sourav,
>
> On 10/29/2012 11:40 AM, Sourav Poddar wrote:
>> Add keypad data node in omap5-evm.
>>
>> Based on I2C support patch for omap5, which has been
>> already posted as a different series.
>>
>> Tested on omap5430 evm with 3.7-rc1 kernel.
>>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>
>> Tested on omap5430 sdp with 3.7-rc1 kernel.
>>
>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
>> ---
>>   arch/arm/boot/dts/omap5-evm.dts |   95 +++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 95 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-evm.dts
>> index c663eba..b812d6d 100644
>> --- a/arch/arm/boot/dts/omap5-evm.dts
>> +++ b/arch/arm/boot/dts/omap5-evm.dts
>> @@ -140,3 +140,98 @@
>>   &mcbsp3 {
>>   	status = "disabled";
>>   };
>> +
>> +&i2c5 {
>> +	clock-frequency = <400000>;
>> +
>> +	smsc@38 {
>> +		compatible = "smscece1099";
>> +		reg = <0x38>;
>> +		clock = <0x13>;
> What does that "clock" mean?
This chip supports a clock control register which is used to enable the
interface used by the chip to communicate. Here, the interface which you 
can are
SMBUS interface or BC-LINK interface.
> I cannot find that in the binding documentation. BTW, did you add that
> documentation in the driver patch?
Nope, I missed out on the dt binding documentation for the driver. :(

Will send a seperate patch for the bindings.
> Regards,
> Benoit
>

