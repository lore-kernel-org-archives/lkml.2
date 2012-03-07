Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2CGK1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:27:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50228 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab2CGK1Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:27:24 -0500
MIME-Version: 1.0
In-Reply-To: <jj684d$6ng$1@ID-44327.news.uni-berlin.de>
References: <201202162251.47063.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1202161722310.1150-100000@iolanthe.rowland.org>
	<CAFLxGvwWBWTmv+uUH87UB3Ly31hjVU5kWpSyihGDKj6_8oc6WA@mail.gmail.com>
	<201202170016.14313.rjw@sisk.pl>
	<jj5qhh$5j5$1@ID-44327.news.uni-berlin.de>
	<jj684d$6ng$1@ID-44327.news.uni-berlin.de>
Date: Wed, 7 Mar 2012 11:27:23 +0100
Message-ID: <CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com>
Subject: Re: Corrupted files after suspend to disk
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 12:54 AM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Andreas Hartmann schrieb:
>> Rafael J. Wysocki schrieb:
>>> On Friday, February 17, 2012, richard -rw- weinberger wrote:
>>>> On Thu, Feb 16, 2012 at 11:26 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>>>>> On Thu, 16 Feb 2012, Rafael J. Wysocki wrote:
>>>>>
>>>>>>> FWIW, we've been seeing a number of hard to diagnose failures
>>>>>>> with suspend to disk for the last few releases in Fedora.
>>>>>>> Eric Sandeen has been chasing https://bugzilla.redhat.com/show_bug.cgi?id=744275
>>>>>>> for a while, but there's no smoking gun that really explains what's
>>>>>>> getting into these states. Further complicating things, is that it
>>>>>>> doesn't seem to be 100% reproducable.
>>>>>>
>>>>>> I wonder if that's reproducible with the filesystems freezing patch I posted
>>>>>> some time ago (it will need some rebasing to apply to the current mainline or
>>>>>> 3.2.y).
>>>>
>>>> Where can I find this patch?
>>>> I'll happily test it.
>>>> But it may take some time as the bug is not easy to reproduce.
>>>
>>> This is the last version posted:
>>>
>>> http://marc.info/?l=linux-kernel&m=132775832509351&w=4
>>>
>>> However, it only may help if you use the kernel-based hibernation i.e.
>>> "echo disk > /sys/power/state" (that may be worth testing without the
>>> patch too, but Fedora is using this AFAICS, so it probably has that
>>> problem too).
>>
>> I'm having the same problem. Please take a look at the following bug
>> report at suse for more information:
>>
>> https://bugzilla.novell.com/show_bug.cgi?id=732908
>>
>> Do you know, which way of suspending openSUSE uses in 12.1?
>
> I changed SLEEP_MODULE="uswsusp" to "kernel" in
> /usr/lib/pm-utils/defaults and tested your patch mentioned above with
> linux 3.2.9.
>
> Unfortunately the behaviour didn't change at all - I can see the same
> problems as before.
>
> I tested with and without X. I tested with the call "pm-hibernate" and
> with "echo disk > /sys/power/state". I always could see the corrupted
> files after 2 to 4 times of hibernating / resuming.
>
>
> Kind regards,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

On my system kernel suspend *seems* to work.
I've seen no corrupted files so far.

But sometimes the resume is failing. (One out of 5 resumes fails).
I was unable to get any kernel output.

So I'm not sure whether this is the same issue
or another one. :-\

-- 
Thanks,
//richard
