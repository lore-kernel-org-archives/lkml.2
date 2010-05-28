Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab0E1MEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:04:32 -0400
Received: from smtp.nokia.com ([192.100.122.233]:16737 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab0E1MEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:04:30 -0400
Message-ID: <4BFFB681.1000105@nokia.com>
Date: Fri, 28 May 2010 15:26:41 +0300
From: Igor Stoppa <igor.stoppa@nokia.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: ext Matthew Garrett <mjg59@srcf.ucam.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "tytso@mit.edu" <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>	<20100527220949.GB10602@srcf.ucam.org>	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>	<20100527223605.GB11364@srcf.ucam.org>	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>	<20100528043114.GC26177@thunk.org>	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk> <20100528114123.GA22947@srcf.ucam.org>
In-Reply-To: <20100528114123.GA22947@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2010 12:03:28.0819 (UTC) FILETIME=[C8D36030:01CAFE5D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Matthew Garrett wrote:

> On Fri, May 28, 2010 at 10:37:13AM +0100, Alan Cox wrote:
>
>   
>> The other vendors appear to be managing nicely without magic blockers. I
>> conjecture therefore there are other solutions.
>>     
>
> Actually, no. A badly behaved application will kill the N900's battery 
> life. Nobody else has "managed nicely" - they've just made life harder 
> for application developers and users, which may have something to do 
> with the relative levels of market adoption of Maemo and Android. I'm 
> not aware of any form of resource management framework in MeeGo either, 
> so as far as I know it'll have exactly the same problem.
>
>   
It's true that a braindead app can kill the battery.

However we provide a version of powertop that is tailored to the N900, 
there is a nokia energy profiler meant to give graphical representation 
of the battery current, there is htop available and you can even get the 
processor activity visualized on the leftmost and rightmost keyboard 
backlight LEDS, when in RD mode and with screen blanked.

I would advice you to not start debating on company strategies, this is 
not the right place.

Otherwise I'll have to ask what's the expected threshold of devices sold 
with broken sw design to get automatic admission into the mainline 
kernel source tree.

But this is not the direction we want to take.

Notice also that we _do_ have a store and official repository where apps 
are monitored for sanity, also with feedback from users and their help 
to promote new apps to trusted state.

Former Maemo 6, now MeeGo do introduce resource management from security 
POV, but that will also have the side effect of discriminating between 
signers.

igor
