Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0JGQeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:34:07 -0400
Received: from mail.atheros.com ([12.19.149.2]:50582 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab0JGQeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:34:05 -0400
Message-ID: <4CADF677.8070506@atheros.com>
Date: Thu, 7 Oct 2010 22:03:59 +0530
From: Bala Shanmugam <sbalashanmugam@atheros.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Marcel Holtmann <holtmann@linux.intel.com>
CC: Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Subject: Re: RFC: btusb firmware load help
References: <1286349552.6145.11.camel@aeonflux>	 <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>	 <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux>	 <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>	 <20101006173949.GG7070@tux>	 <1286387660.3655.382.camel@jlt3.sipsolutions.net>	 <AANLkTikYRSQw-+Tcj4VS1qxi=OaeF9C5hjAMWVu+0M=v@mail.gmail.com>	 <AANLkTi=o4Mc72NrNoALBdS3YHeY7RMyyAJPsCy=uW3+F@mail.gmail.com>	 <1286389697.3655.401.camel@jlt3.sipsolutions.net>	 ,<20101006183340.GI7070@tux>	 <44EE5C37ADC36343B0625A05DD408C4850DAD2CA31@CHEXMB-01.global.atheros.com> <1286465072.6145.151.camel@aeonflux>
In-Reply-To: <1286465072.6145.151.camel@aeonflux>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/7/2010 8:54 PM, Marcel Holtmann wrote:
> Hi Bala,
>
>> Thanks Johannes.  This would be better option to change PID in firmware
>> as blacklisting 3002 might create problems for 3011 chipsets.
>> Will try and let you people know.
> The misbehaving 3002 needs to be blacklisted in btusb.c anyway. However
> after loading the firmware to 3002 device, it should change its PID to
> something else.
>
> I am still trying to figure out if this is one stage firmware loading or
> a two stage firmware loading. This is all pretty unclear and nobody has
> answered this clearly so far.
>
> Regards
>
> Marcel
>
>
h
