Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3ADVkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:40:12 -0500
Received: from cpsmtp-fia01.kpnxchange.com ([195.121.247.4]:3940 "EHLO
	cpsmtp-fia01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754963Ab3ADVkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:40:10 -0500
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2013 16:40:10 EST
Message-ID: <50E748C7.10202@xs4all.nl>
Date: Fri, 04 Jan 2013 22:25:27 +0100
From: Kees Bakker <kees.bakker@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: drm/nouveau E[     DRM] fail ttm_validate
References: <65b9.50e6c93a.b1791@altium.nl> <65b9.50e6c93a.b1791@altium.nl> <20130104174958.GA15275@joi.lan>
In-Reply-To: <20130104174958.GA15275@joi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jan 2013 21:26:01.0021 (UTC) FILETIME=[17F6AED0:01CDEAC2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-01-13 18:49, Marcin Slusarz wrote:
> On Fri, Jan 04, 2013 at 01:21:14PM +0100, Kees Bakker wrote:
>> Hi,
>>
>> Right after I upgraded to Ubuntu quantal I started seeing these
>> messages:
>> Jan  4 12:18:12 koli kernel: [ 3705.970720] nouveau E[     DRM] fail ttm_validate
>> Jan  4 12:18:12 koli kernel: [ 3705.970726] nouveau E[     DRM] validate vram_list
>> Jan  4 12:18:12 koli kernel: [ 3705.970760] nouveau E[     DRM] validate: -12
> This is userspace bug. See below.
>
>> A few times I had corrupted graphics, and I had to stop X. Restarting didn't
>> help and I had to reboot.
>>
>> I'm running my own 3.7.1 kernel, so I also installed the 3.7.0 development kernel
>> from Ubuntu (3.7.0-7). And that kernel shows these messages too.
>>
>> With the Ubuntu kernel the graphics corruption is milder. I can continue to work. Sometimes
>> I get a burst of the messages, but I have no clue how it is triggered.
>>
>> Now the strange thing is that I was running my 3.7.1 kernel on Ubuntu precise
>> and I have never seen these messages before. What could be the case is that
>> xorg is doing something new and that is causing the errors.
>>
>> xserver-xorg-video-nouveau
>>     precise 1:1.0.2-0ubuntu3
>>     quantal 1:0.0.16+git20111201+b5534a1-1build2
> (Please do not use distro codenames when reporting bugs upstream)
>
> Quantal, being newer release than Precise, ships much older Nouveau DDX, WTF?
> You used some PPA with Precise?
Sorry about that. That was a typo. I meant to say:
    quantal 1:1.0.2-0ubuntu3
    precise 1:0.0.16+git20111201+b5534a1-1build2

>
> 0.0.16 is known to behave like that - you need to upgrade to >= 1.0.

In other words, I have >= 1.0. But you suggest that it shouldn't
happen with >= 1.0
Should I report it on the nouveau list at freedesktop.org ?
-- 
Kees

