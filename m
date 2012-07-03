Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab2GCTfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:35:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56852 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032Ab2GCTfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120628081607.GG31944@gamma.logic.tuwien.ac.at>
References: <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com>
	<20120413014047.GB25681@gamma.logic.tuwien.ac.at>
	<20120330011734.GH6277@gamma.logic.tuwien.ac.at>
	<20120411023747.GA10126@gamma.logic.tuwien.ac.at>
	<4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com>
	<20120412000202.GA15286@gamma.logic.tuwien.ac.at>
	<20120628072512.GF31944@gamma.logic.tuwien.ac.at>
	<1340869868.4491.4.camel@jlt3.sipsolutions.net>
	<20120628081607.GG31944@gamma.logic.tuwien.ac.at>
Date: Tue, 3 Jul 2012 21:35:43 +0200
Message-ID: <CAKWSe6C_rEQgcB5Hg2DXJpTL-g+zsPbTzmO+fh86+EW+vbzFvA@mail.gmail.com>
Subject: Re: [Ilw] Re: 3.4-rc2, ilwagn still most of the time completely unusable
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
        "Lin, Hsien KuoX" <hsien.kuox.lin@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <egrumbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 10:16 AM, Norbert Preining <preining@logic.at> wrote:
> On Do, 28 Jun 2012, Johannes Berg wrote:
>> Somehow your mail didn't make it to the lists, not sure why.
>
> Hmm, yeah, some of the emails were privte exchange with
> Venkataraman and Lin.
>
>> Fun. I don't actually see how this can possibly happen though?!
>
> Hmm, actually I think I have seen similar things quite regularly,
> and reported them also.
>
>> > > > >   [ 9457.176828] iwlwifi 0000:06:00.0: ACTIVATE a non DRIVER active
>> > > > >station id 0 addr 00:24:c4:ab:bd:e0
>> >
>> > These messages now appear only now and then.
>>
>> I fixed those recently.
>
> Good.

Just a report to say that I still see those in 3.5.0-rc5.

I recently moved from a Dell Latitude 6400, with a bcm4322 chip managed
 by the Broadcom-STA out-of-tree driver (wl module) to the new Latitude 6420,
 which has this as per lspci:

02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 (rev 34)

 and I have two issues compared to the bcm4322; one is the above message,
 which appears when the driver can't associate to my D-Link DSL2740B router;
 telnetting into the router and bouncing its AP component via wlctl is enough
 to allow the laptop to connect again.
At the same time, my wife's old 32-bit Dell D610 with an ipw2200 connects just
 fine to the DSL-2740B.


The second issue is that the wifi speed is much lower with the new 6420 under
 iwlwifi - topping out at under 3MB/s compared with peaks of 10MB/s with the
 bcm4322's wl driver, which hardly ever went under 6MB/s.

iwconfig wlan0 reports fluctuating bitrates of 18/24/36 Mb/s whereas I could see
 very easily 130Mb/s with the wl driver. Maybe something is also due to the fact
 that the DSL-2740B has a draft-N implementation and its Broadcom chip has
 better feelings with the laptop's Broadcom wl than the iwlwifi.


I'm available for more detailed reporting and testing.

Thanks,

>> You seem to be on 3.5.0-rc now, is that really no different from 3.4?
>
> The feeling is that it is definitely better.
>
> I can actually work now wirelessly, and in case of hangs an rfkill block
> rfkill unblock practically always, and mostly is not needed.
>
> So yes, it is better, definitely.
>
> I think till 3.4 I had to use the cable quite regularly.
>
> Best wishes
>
> Norbert

--alessandro

"don't underestimate the things that I will do"

 (Adele, "Rolling In The Deep")
