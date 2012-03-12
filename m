Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2CLN03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:26:29 -0400
Received: from mout0.freenet.de ([195.4.92.90]:56152 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab2CLN01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:26:27 -0400
Message-ID: <4F5DF8F0.5010801@01019freenet.de>
Date: Mon, 12 Mar 2012 14:24:00 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Firefox/10.0.2 SeaMonkey/2.7.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: Corrupted files after suspend to disk
References: <201202162251.47063.rjw@sisk.pl> <Pine.LNX.4.44L0.1202161722310.1150-100000@iolanthe.rowland.org> <CAFLxGvwWBWTmv+uUH87UB3Ly31hjVU5kWpSyihGDKj6_8oc6WA@mail.gmail.com> <201202170016.14313.rjw@sisk.pl> <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de> <jj684d$6ng$1@ID-44327.news.uni-berlin.de> <CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com> <4F574113.8030906@01019freenet.de> <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz> <CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com> <alpine.LNX.2.00.1203121329430.18356@pobox.suse.cz> <CAFLxGvyXwFwLRYw7=eHGLZsiAB9Adcu16z=UPhLtL_Ze3bF-9g@mail.gmail.com> <alpine.LNX.2.00.1203121402460.18356@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1203121402460.18356@pobox.suse.cz>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina schrieb:
> On Mon, 12 Mar 2012, richard -rw- weinberger wrote:
> 
>>>>> This is happening to me as well. Something like 1 resume out of 5 goes
>>>>> wrong this very same way.
>>>>>
>>>>> This is thinkpad x200s.
>>>>>
>>>>> All the userspace is segfaulting all over the place (most frequently in
>>>>> libselinux for some reason).
>>>>>
>>>>> I am not able to verify the 'drop_caches' theory, as I can't invoke a
>>>>> single command that wouldn't crash.
>>>>
>>>> The question is how should we proceed?
>>>> I've reported this issue one year (!!!) ago.
>>>
>>> Hmm, 3.3-rcX seems to be the first version when it started to happen to
>>> me. I take it that you have seen this also with 3.2? 3.1?
>>
>> Quote from my very first email:
>> "I'm facing a very strange problem on my netbook (Lenovo Ideapad S10)
>> running Linux 2.6.37.4."
> 
> So we both seem to have Lenovos at least. I thus wanted to verify whether 
> the problem will trigger with thinkpad_acpi removed, but it oopsed while 
> rmmoding :) I will start looking into this right away.
> 
> Is your system using thinkpad_acpi as well?

I dont't think, that it is lenovo related as I'm having a MSI machine.

https://bugzilla.novell.com/show_bug.cgi?id=732908

Following the link, you are able to compare the used chips - maybe there
are some equal components?


Regards,
Andreas
