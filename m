Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1HBVBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:01:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35719 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab1HBVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:00:59 -0400
Message-ID: <4E386588.8060503@gmail.com>
Date: Tue, 02 Aug 2011 23:00:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110729 Thunderbird/6.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Francis Moreau <francis.moro@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com> <20110731110641.GG2209@sun> <4E353A41.2010405@gmail.com> <20110802194855.GA3593@redhat.com>
In-Reply-To: <20110802194855.GA3593@redhat.com>
X-Enigmail-Version: 1.3a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 09:48 PM, Don Zickus wrote:
> On Sun, Jul 31, 2011 at 01:19:29PM +0200, Jiri Slaby wrote:
>> On 07/31/2011 01:06 PM, Cyrill Gorcunov wrote:
>>> On Sun, Jul 31, 2011 at 08:56:30AM +0200, Francis Moreau wrote:
>>>> Hello,
>>>>
>>>> I'm seeing those kernel message when resuming:
>>>>
>>>> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
>>>> [  524.973288] Do you have a strange power saving mode enabled?
>>>> [  524.973289] Dazed and confused, but trying to continue
>>>>
>>>> I don't know if it's important or not because the system seems to work
>>>> after but maybe it worths to report
>>>>
>>>
>>> Hi Francis, cpu please?
>>
>> Hi, I'm seeing those too. For a longer time though. Please see
>> https://bugzilla.novell.com/show_bug.cgi?id=678882#c16
> 
> That is with 2.6.37.  Lots of watchdog/perf nmi fixes have been added
> since then (though dmesg suggests the watchdog is disabled due to a broken
> PMU).

No, comment 16 (the link above) is about 3.0.

> I think for the Core iX family, 2.6.39 and higher have been stable.

It looks like not quite...

regards,
-- 
js
