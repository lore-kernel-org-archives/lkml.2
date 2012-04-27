Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296Ab2D0TWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:22:25 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55111 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760458Ab2D0TWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:22:24 -0400
Message-ID: <4F9AF1E4.4000600@linaro.org>
Date: Fri, 27 Apr 2012 12:22:12 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com> <4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com> <4F8C3DDF.8030103@teksavvy.com> <CAFLxGvy=3SHKFYoSfUcQrJKsCYWq5Fxpi4q_DTQjjFNDSSnJOw@mail.gmail.com> <4F8C415C.80806@teksavvy.com> <4F8C76EB.20709@linaro.org> <4F8C926D.2040503@linaro.org> <4F8CD5D3.8060006@teksavvy.com> <4F8CFC12.6050700@linaro.org> <4F8DCE74.2020906@teksavvy.com> <4F8DF673.8050605@linaro.org> <4F8E18FA.7040602@teksavvy.com> <4F8F0811.5060407@linaro.org> <4F9AAE43.5080809@teksavvy.com>
In-Reply-To: <4F9AAE43.5080809@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042719-5806-0000-0000-000014AF8C8F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 07:33 AM, Mark Lord wrote:
> On 12-04-18 02:29 PM, John Stultz wrote:
>> On 04/17/2012 06:29 PM, Mark Lord wrote:
>>> I'll give the suggestions above a go when I get the system back.
>>> Right now it's out on loan for application testing.
>>>
>>> And there is a simple workaround for that system, which I'm now using:
>>> just disable the RTC Alarm in the BIOS and the issue goes away.
>>> And as you point out, hwclock does seem to be diddling with the Alarm
>>> for some reason, so I'm feeling this isn't so important any more.
>>>
>>> But as we've gone this far, I will instrument things as requested
>>> when I get the system back in a few days.
>> Once again, thanks so much for reporting the issue and help with testing! I know going through
>> remote diagnostics is a pain, especially when you have a workaround. :)  Anyway, your help here is
>> very much appreciated.
> Mmm.. at this point I may not get that system back here again.
> The fellow who has it wants to hang onto it.
>
> So.. nothing.  :)
Ok. Well, do let me know if you end up seeing anything similar. Thanks 
again for your testing and bug reports.

thanks
-john

