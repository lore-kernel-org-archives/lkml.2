Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2LUOnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:43:17 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58629 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2LUOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:43:08 -0500
MIME-Version: 1.0
In-Reply-To: <50D464D8.8070706@nvidia.com>
References: <1356082135-14549-1-git-send-email-ldewangan@nvidia.com>
	<CAHdPZaPJpB4Rzg1=DQr4udmp3-WCo8YLXVqribBw2o6HRiVU2Q@mail.gmail.com>
	<50D464D8.8070706@nvidia.com>
Date: Fri, 21 Dec 2012 20:13:07 +0530
Message-ID: <CAHdPZaO4rtRv-6Z1yix06MXhoU-ZVqaJZyoBCdZPXmTRa2526g@mail.gmail.com>
Subject: Re: [PATCH] rtc: add RTC driver for TPS6586x
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Andrew Morton <akpm@linuxfoundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 7:02 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Hi Devendra,
> Thanks for quick review.
>
> All comments has been taken care. except
>
>
> On Friday 21 December 2012 06:16 PM, devendra.aaru wrote:
>
>> so its better if you have this function down the registering the device.
>>
>> btw you may even remove disable_irq if you register below the
>> registering of device.
>
> When I do request_irq() the interrupt already enable. I want to disable
> until someone set alarm.
>
> So In this case, I can not get rid of this call.
>
Ok, nice to know :).
