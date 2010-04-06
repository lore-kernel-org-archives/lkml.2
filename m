Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab0DFSTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:19:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39833 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757492Ab0DFSS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:58 -0400
References: <2122967437.461270223106350.JavaMail.root@mail.savoirfairelinux.com>	<1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com>	<20100402160058.GE27613@sirena.org.uk>	<20100402184403.2ea1263e@hyperion.delvare>	<20100402185138.GA12817@opensource.wolfsonmicro.com>	<20100402213010.4a64e50f@hyperion.delvare>	<20100402204503.GA15237@opensource.wolfsonmicro.com>	<20100403173745.2bf17ee6@hyperion.delvare>	<20100405132347.GA6580@rakim.wolfsonmicro.main> <1270567639.3229.56.camel@odin> <4BBB6083.2070903@cam.ac.uk> (sfid-20100406_172304_064433_7FBC3A75)
Message-Id: <1F9C625F-0467-4C6D-B57F-2E4FCAC76031@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
In-Reply-To: <4BBB6083.2070903@cam.ac.uk> (sfid-20100406_172304_064433_7FBC3A75)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7E18)
Mime-Version: 1.0 (iPhone Mail 7E18)
Subject: Re: [lm-sensors] regulator: regulator_get behaviour without CONFIG_REGULATOR set
Date: Tue, 6 Apr 2010 19:19:47 +0100
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jean Delvare <khali@linux-fr.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Apr 2010, at 17:25, Jonathan Cameron <jic23@cam.ac.uk> wrote:

> On 04/06/10 16:27, Liam Girdwood wrote:
>>>
>>>
>>>
>>
>> I suppose this is something we may look into more when we have more
>> clients.
> Makes sense.  There will probably be quite a few IIO drivers over  
> the next
> few months doing much the same as sht15, where the voltage ref for  
> devices
> may well be fed by a regulator.  In that case, we may only offer the  
> option
> of using an external v_ref if the regulator is available.  Many  
> devices have
> an internal regulator to provide it so typically we'll start them up  
> using that
> and provide an interface to switch to external regulator if one is  
> available.
> I haven't thought through exactly how this will work as yet. I'll cc  
> people in
> when this comes up.

TBH this seems like a very vanilla use case - there may be some small  
advantage to representing the internal regulator via the regulator API  
but that's about the only thing I can think might be a bit odd.
