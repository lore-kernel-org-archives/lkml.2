Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701Ab0JGPMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:12:31 -0400
Received: from mail.atheros.com ([12.19.149.2]:46943 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023Ab0JGPMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:12:30 -0400
From: Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@Atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
        Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
        Marcel Holtmann <holtmann@linux.intel.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@Atheros.com>,
        Sree Durbha <Sree.Durbha@Atheros.com>
Date: Thu, 7 Oct 2010 20:39:37 +0530
Subject: RE: RFC: btusb firmware load help
Thread-Topic: RFC: btusb firmware load help
Thread-Index: ActlhQm3RoIP0ZJJQwKGzIeE+W1DKwArJ6UW
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAD2CA31@CHEXMB-01.global.atheros.com>
References: <1286349552.6145.11.camel@aeonflux>
 <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
 <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux>
 <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
 <20101006173949.GG7070@tux>
 <1286387660.3655.382.camel@jlt3.sipsolutions.net>
 <AANLkTikYRSQw-+Tcj4VS1qxi=OaeF9C5hjAMWVu+0M=v@mail.gmail.com>
 <AANLkTi=o4Mc72NrNoALBdS3YHeY7RMyyAJPsCy=uW3+F@mail.gmail.com>
 <1286389697.3655.401.camel@jlt3.sipsolutions.net>,<20101006183340.GI7070@tux>
In-Reply-To: <20101006183340.GI7070@tux>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: linux-bluetooth-owner@vger.kernel.org [linux-bluetooth-owner@vger.kernel.org] On Behalf Of Luis R. Rodriguez [lrodriguez@atheros.com]
Sent: Thursday, October 07, 2010 12:03 AM
To: Johannes Berg
Cc: Luis Rodriguez; Marcel Holtmann; linux-bluetooth; linux-kernel@vger.kernel.org; linux-wireless@vger.kernel.org; Deepak Dhamdhere; Sree Durbha
Subject: Re: RFC: btusb firmware load help

On Wed, Oct 06, 2010 at 11:28:17AM -0700, Johannes Berg wrote:
> On Wed, 2010-10-06 at 11:26 -0700, Luis R. Rodriguez wrote:
>
> > > Good idea, I forgot about possible firmware changes :) Lets see if our
> > > team can do that. Thanks for all the feedback.
> >
> > Deepak a proof of concept test can involve simply hex-editing the
> > ath3k-1.fw and replacing 0x3002 to 0x3003, then the above patch might
> > work.
>
> $ hd ath3k-1.fw
> ...
> 00000670  00 00 00 00 00 00 00 00  00 00 00 00 f3 0c 02 30  |...............0|
> 00000680  12 01 10 01 e0 01 01 40  f3 0c 02 30 01 00 00 00  |.......@...0....|
> ...
>
> that looks a lot like the IDs right there, in little endian :-)

>Furthermore another idea by johannes is that if we cannot fix this
>in firmware by changing the exposed device ID, we could just check
>in btusb for some USB component that would come alive once the firmware
>does get loaded, like endpoints, or speed, or whatever. But that would
>be last resort.

 > Luis
>--
>To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks Johannes.  This would be better option to change PID in firmware
as blacklisting 3002 might create problems for 3011 chipsets.
Will try and let you people know. 

Regards,
Bala.