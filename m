Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031549Ab2CFWxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:53:54 -0500
Received: from mout6.freenet.de ([195.4.92.96]:46872 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031276Ab2CFWxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:53:53 -0500
X-Greylist: delayed 5580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2012 17:53:52 EST
From: Andreas Hartmann <andihartmann@01019freenet.de>
X-Newsgroups: gmane.linux.power-management.general,linux.kernel
Subject: Re: Corrupted files after suspend to disk
Date: Tue, 06 Mar 2012 21:03:00 +0100
Organization: privat
Message-ID: <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de>
References: <201202162251.47063.rjw@sisk.pl> <Pine.LNX.4.44L0.1202161722310.1150-100000@iolanthe.rowland.org> <CAFLxGvwWBWTmv+uUH87UB3Ly31hjVU5kWpSyihGDKj6_8oc6WA@mail.gmail.com> <201202170016.14313.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Firefox/10.0.2 SeaMonkey/2.7.2
In-Reply-To: <201202170016.14313.rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schrieb:
> On Friday, February 17, 2012, richard -rw- weinberger wrote:
>> On Thu, Feb 16, 2012 at 11:26 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>>> On Thu, 16 Feb 2012, Rafael J. Wysocki wrote:
>>>
>>>>> FWIW, we've been seeing a number of hard to diagnose failures
>>>>> with suspend to disk for the last few releases in Fedora.
>>>>> Eric Sandeen has been chasing https://bugzilla.redhat.com/show_bug.cgi?id=744275
>>>>> for a while, but there's no smoking gun that really explains what's
>>>>> getting into these states. Further complicating things, is that it
>>>>> doesn't seem to be 100% reproducable.
>>>>
>>>> I wonder if that's reproducible with the filesystems freezing patch I posted
>>>> some time ago (it will need some rebasing to apply to the current mainline or
>>>> 3.2.y).
>>
>> Where can I find this patch?
>> I'll happily test it.
>> But it may take some time as the bug is not easy to reproduce.
> 
> This is the last version posted:
> 
> http://marc.info/?l=linux-kernel&m=132775832509351&w=4
> 
> However, it only may help if you use the kernel-based hibernation i.e.
> "echo disk > /sys/power/state" (that may be worth testing without the
> patch too, but Fedora is using this AFAICS, so it probably has that
> problem too).

I'm having the same problem. Please take a look at the following bug
report at suse for more information:

https://bugzilla.novell.com/show_bug.cgi?id=732908

Do you know, which way of suspending openSUSE uses in 12.1?

Is the above mentioned patch already part of kernel 3.3?


Thank you,
kind regards,
Andreas
