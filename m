Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab0JGQdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:33:00 -0400
Received: from mail.atheros.com ([12.19.149.2]:50511 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab0JGQc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:32:59 -0400
Message-ID: <4CADF634.1030203@atheros.com>
Date: Thu, 7 Oct 2010 22:02:52 +0530
From: Bala Shanmugam <sbalashanmugam@atheros.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Marcel Holtmann <holtmann@linux.intel.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Subject: Re: RFC: btusb firmware load help
References: <1286349552.6145.11.camel@aeonflux>	 <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>	 <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux>	 <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>	 <20101006173949.GG7070@tux>	 <1286387660.3655.382.camel@jlt3.sipsolutions.net>	 <AANLkTikYRSQw-+Tcj4VS1qxi=OaeF9C5hjAMWVu+0M=v@mail.gmail.com>	 <AANLkTi=o4Mc72NrNoALBdS3YHeY7RMyyAJPsCy=uW3+F@mail.gmail.com>	 <1286389697.3655.401.camel@jlt3.sipsolutions.net>	 ,<20101006183340.GI7070@tux>	 <44EE5C37ADC36343B0625A05DD408C4850DAD2CA31@CHEXMB-01.global.atheros.com> <1286464555.20974.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286464555.20974.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/7/2010 8:45 PM, Johannes Berg wrote:
>> Thanks Johannes.  This would be better option to change PID in firmware
>> as blacklisting 3002 might create problems for 3011 chipsets.
> What would be the problem with 3011? Does it also use the 3002 ID, but
> not use firmware upload???
>
> johannes
>
AR3011 when plugged-in uses PID 3000 and control goes to DFU driver [ath3k].
ath3k downloads the firmware to the device changing its PID to 3002.
Now btusb gets the control and attaches the device to bluetooth core.

So blacklisting 3002 in btusb will create issues for AR3011 chipsets.
In firmware if we change the PID from 3002 to 3003 as you suggested and 
blacklist 3002 in btusb
we can make both devices work.

Regards,
Bala.
