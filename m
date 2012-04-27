Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257Ab2D0Odl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:33:41 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:62355 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256Ab2D0Odk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:33:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGLAEBAQEDI1UBEAsYAgIFFgsCAgkDAgECAUUGDQEHAQG0JIoYgS+OE4EYBKklgTgW
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="177115465"
Message-ID: <4F9AAE43.5080809@teksavvy.com>
Date: Fri, 27 Apr 2012 10:33:39 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com> <4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com> <4F8C3DDF.8030103@teksavvy.com> <CAFLxGvy=3SHKFYoSfUcQrJKsCYWq5Fxpi4q_DTQjjFNDSSnJOw@mail.gmail.com> <4F8C415C.80806@teksavvy.com> <4F8C76EB.20709@linaro.org> <4F8C926D.2040503@linaro.org> <4F8CD5D3.8060006@teksavvy.com> <4F8CFC12.6050700@linaro.org> <4F8DCE74.2020906@teksavvy.com> <4F8DF673.8050605@linaro.org> <4F8E18FA.7040602@teksavvy.com> <4F8F0811.5060407@linaro.org>
In-Reply-To: <4F8F0811.5060407@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-18 02:29 PM, John Stultz wrote:
> On 04/17/2012 06:29 PM, Mark Lord wrote:
>> I'll give the suggestions above a go when I get the system back.
>> Right now it's out on loan for application testing.
>>
>> And there is a simple workaround for that system, which I'm now using:
>> just disable the RTC Alarm in the BIOS and the issue goes away.
>> And as you point out, hwclock does seem to be diddling with the Alarm
>> for some reason, so I'm feeling this isn't so important any more.
>>
>> But as we've gone this far, I will instrument things as requested
>> when I get the system back in a few days.
> Once again, thanks so much for reporting the issue and help with testing! I know going through
> remote diagnostics is a pain, especially when you have a workaround. :)  Anyway, your help here is
> very much appreciated.

Mmm.. at this point I may not get that system back here again.
The fellow who has it wants to hang onto it.

So.. nothing.  :)

