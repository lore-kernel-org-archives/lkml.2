Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab1I2JwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:52:07 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57217 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1I2JwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:52:05 -0400
MIME-Version: 1.0
In-Reply-To: <007801cc7e75$13dfcfd0$3b9f6f70$%kim@samsung.com>
References: <CADUNanhyOg-mJtBQ1WFh_YfO0b73JEiOLLowC8fHbwgdkMDaHw@mail.gmail.com>
	<007201cc7e6f$6019b970$204d2c50$%kim@samsung.com>
	<CADUNanjVncrzeMofSMZGhKOcYu1qbh4ZcBjziOPFU+wkE6MXbw@mail.gmail.com>
	<007801cc7e75$13dfcfd0$3b9f6f70$%kim@samsung.com>
Date: Thu, 29 Sep 2011 15:22:03 +0530
Message-ID: <CADUNanhXo20thoABe7thTsKG88pU+Avy=zd-0nXpiqyimhS=iA@mail.gmail.com>
Subject: Re: {Question] Is "kernel.org" down ?
From: santosh <santosh.iitg@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to all of you.


--Santosh

On Thu, Sep 29, 2011 at 12:27 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Santosh wrote:
>>
>> Kgene,
>>
>> https://github.com/torvalds/linux.git
>>
>> Thanks for your response. I could not find location in that site to
>> download linux kernel.
>>
>> I need  2.6.38 kernel source.  Can you please help me out ?
>>
> Hi Santosh,
>
> Please refer to below...
>
> $ git clone git://github.com/torvalds/linux.git
>
> $ cd linux
>
> $ git checkout v2.6.38
> Or $ git reset --hard v2.6.38
> Or $ git checkout -b [local branch] v2.6.38
>
> Actually, there are many ways and above is one of them...
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
>
>> Thanks
>> Santosh
>>
>> On Thu, Sep 29, 2011 at 11:46 AM, Kukjin Kim <kgene.kim@samsung.com>
> wrote:
>> > santosh wrote:
>> >>
>> >> Hi
>> >>
>> >>  http://kernel.org/
>> >>
>> >> When I try to browse the above site, it shows "Down for maintenance".
>> >> If it is down then from where I can download kernel source ??
>> >>
>> >
>> > You can get it from following:
>> >  git://github.com/torvalds/linux.git
>> >
>> > Thanks.
>> >
>> > Best regards,
>> > Kgene.
>> > --
>> > Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
>> > SW Solution Development Team, Samsung Electronics Co., Ltd.
>> >
>> >
>
>
