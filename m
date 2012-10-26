Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab2JZNre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:47:34 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:47573 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2JZNrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:47:33 -0400
Message-ID: <508A945C.4010006@free-electrons.com>
Date: Fri, 26 Oct 2012 15:47:08 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Jason Cooper <jason@lakedaemon.net>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/4] arm: mvebu: adding SATA support: dt binding for
 Armada 370/XP
References: <1351254650-26861-1-git-send-email-gregory.clement@free-electrons.com> <1351254650-26861-3-git-send-email-gregory.clement@free-electrons.com> <20121026133154.GN18811@titan.lakedaemon.net> <20121026133446.GM21046@lunn.ch>
In-Reply-To: <20121026133446.GM21046@lunn.ch>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 03:34 PM, Andrew Lunn wrote:
> On Fri, Oct 26, 2012 at 09:31:54AM -0400, Jason Cooper wrote:
>> On Fri, Oct 26, 2012 at 02:30:47PM +0200, Gregory CLEMENT wrote:
>>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>>> Signed-off-by: Lior Amsalem <alior@marvell.com>
>>> ---
>>>  arch/arm/boot/dts/armada-370-xp.dtsi |    9 +++++++++
>>>  1 file changed, 9 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
>>> index 94b4b9e..a911f7a 100644
>>> --- a/arch/arm/boot/dts/armada-370-xp.dtsi
>>> +++ b/arch/arm/boot/dts/armada-370-xp.dtsi
>>> @@ -69,6 +69,15 @@
>>>  			compatible = "marvell,armada-addr-decoding-controller";
>>>  			reg = <0xd0020000 0x258>;
>>>  		};
>>> +
>>> +		sata@d00a0000 {
>>> +                        compatible = "marvell,orion-sata";
>>> +                        reg = <0xd00a0000 0x2400>;
>>> +                        interrupts = <55>;
>>> +			clocks = <&coreclk 0>;
>>
>> nit. whitespace?
> 
> [Don't shoot the messenger]
> 
> How about extending checkpatch to check for this? I guess its just
> spaces which should be tabs.

No it is the opposite in fact! On this line it's tabs: 3 tabs of 8
whitespace, so the line start at 24. But as there is a '+', the first
tab is only 7, so it is still start at 24. Whereas for the other lines
it's 24 white spaces, so with the '+' it starts at 25. That's why I
didn't notice it, and if you apply the patch all is fine.

Now, about white spaces vs tab, I don't know what is the rule for .dts
file.


Gregory
