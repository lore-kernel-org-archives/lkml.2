Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab1BNTzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:55:45 -0500
Received: from mail.tmr.com ([64.65.253.246]:49264 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab1BNTzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:55:43 -0500
X-Greylist: delayed 1510 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Feb 2011 14:55:42 EST
Message-ID: <4D5982D6.2060102@tmr.com>
Date: Mon, 14 Feb 2011 14:30:30 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101123 Lightning/1.0b2 SeaMonkey/2.0.11
MIME-Version: 1.0
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        kernel-testers@vger.kernel.org
Subject: Re: [Bug #28622] radeon video lockup
References: <9Pzlq5PlEtH.A.DU.efxVNB@chimera> <1z1FRILH7uF.A.ib.rfxVNB@chimera> <alpine.DEB.2.00.1102121610460.4146@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1102121610460.4146@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Sun, 13 Feb 2011, Rafael J. Wysocki wrote:
>
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.36 and 2.6.37.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.36 and 2.6.37. Please verify if it still should
>> be listed and let the tracking team know (either way).
>>
>>
>> Bug-Entry : http://bugzilla.kernel.org/show_bug.cgi?id=28622
>> Subject : radeon video lockup
>> Submitter : Daniel Poelzleithner <bugzilla.kernel.org@poelzi.org>
>> Date : 2011-02-08 17:48 (5 days old)
>
> hmm, I've occasionally been expericancing what sounds like a similar issue.
>
> the screen locks, it doesn't respond to the keyboard (but caps lock
> still works), frequently the mouse pointer still moves, but you can't
> click on anything.
>
> it ususally happens to me a few min after starting firefox (with 10-15
> windows holding a couple hundred tabs), so it could also be a firefox
> bug if it can capture the input and not release it.
>
> I've experianced this on my T61 laptop, and my work machine (Radeon
> X1300 series)
>
> I'm currently running ubuntu 10.10 which is 2.6.35-25, so if it is the
> same problem, it wasn't introduced between 2.6.36 and 2.6.37.
>
> like the OP of the bug report, this is not something that happens
> frequently, but I don't do much that stresses the video, so starting all
> these tabs is about as hard as I drive it.
>
> David Lang
There have been several recent reports of lockups, with nothing in the logs or 
nothing recoverable. I've seen some of these running the git3 kernel on a VM 
(Fedora 14) so it may not be related to the specific video card but to X in general.

I've had too little information to justify a proper bug report.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
