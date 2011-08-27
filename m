Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1H0WvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 18:51:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43282 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1H0WvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 18:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <1314435638.2321.12.camel@thor.local>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
 <1314435638.2321.12.camel@thor.local>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Sat, 27 Aug 2011 18:50:37 -0400
Message-ID: <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
To: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>
Cc: dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/27 Michel Dänzer <michel@daenzer.net>:
>> I observe very strange behavior dependent on value of
>> CONFIG_DRM_RADEON parameter. When it's set to m everything works very
>> good, no problem. When I set it to y I see kernel hang during boot. Or
>> I should better say it "almost hangs" because during last boot attempt
>> I accidentally waited a little bit longer and saw that after more than
>> a minute waiting system continued to boot. Dmesg after "hang" shows
>> these messages:
>>
>> [    8.542639] [drm] Loading CEDAR Microcode
>> [   69.161605] r600_cp: Failed to load firmware "radeon/CEDAR_pfp.bin"
>> [   69.161670] [drm:evergreen_startup] *ERROR* Failed to load firmware!
>>
>> While during normal boot
>>
>> [    9.898870] [drm] Loading CEDAR Microcode
>> [    9.908425] radeon 0000:05:00.0: WB enabled
>
> With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
> loaded from userspace, so it needs to be built into the kernel as well.

How should I do that? I've tried to set all "m"s to "y" in .config and
still saw this issue. Should I set some special parameter?


Pavel
