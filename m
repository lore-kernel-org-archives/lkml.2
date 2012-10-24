Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894Ab2JXOGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:06:04 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:49282 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934814Ab2JXOGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:06:02 -0400
Message-ID: <5087F5B9.0@free-electrons.com>
Date: Wed, 24 Oct 2012 16:05:45 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm: mvebu: adding SATA support: dt binding and config
 update
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com> <1351086561-13569-3-git-send-email-gregory.clement@free-electrons.com> <20121024160139.6dbf5e16@skate>
In-Reply-To: <20121024160139.6dbf5e16@skate>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 04:01 PM, Thomas Petazzoni wrote:
> Hello,
> 
> Shouldn't you split into one commit adding the SATA definition in
> the .dtsi + doing the defconfig change (the "SoC" level modifications),
> and then another commit for the .dts change? I don't really care
> personally, it's really up to Jason/Andrew on this.
> 
> Another comment below, though.
> 
> On Wed, 24 Oct 2012 15:49:21 +0200, Gregory CLEMENT wrote:
> 
>> diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
>> index 94b4b9e..3f08233 100644
>> --- a/arch/arm/boot/dts/armada-370-xp.dtsi
>> +++ b/arch/arm/boot/dts/armada-370-xp.dtsi
>> @@ -69,6 +69,16 @@
>>  			compatible = "marvell,armada-addr-decoding-controller";
>>  			reg = <0xd0020000 0x258>;
>>  		};
>> +
>> +		sata@d00a0000 {
>> +                        compatible = "marvell,orion-sata";
>> +                        reg = <0xd00a0000 0x2400>;
>> +                        interrupts = <55>;
>> +                        nr-ports = <2>;
>> +			clocks = <&coreclk 0>;//,  <&coreclk 0>;
> 
> Alignment problem + remainings of tests or something like that.

True I missed this one.

Jason, Andrew, do you want I split this patch as suggested by Thomas or
are you fine with having one single patch?

I will wait your answer before sending the V2.

Thanks,

Gregory
