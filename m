Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2CLViq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:38:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52495 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2CLVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:38:43 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1203121402460.18356@pobox.suse.cz>
References: <201202162251.47063.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1202161722310.1150-100000@iolanthe.rowland.org>
	<CAFLxGvwWBWTmv+uUH87UB3Ly31hjVU5kWpSyihGDKj6_8oc6WA@mail.gmail.com>
	<201202170016.14313.rjw@sisk.pl>
	<jj5qhh$5j5$1@ID-44327.news.uni-berlin.de>
	<jj684d$6ng$1@ID-44327.news.uni-berlin.de>
	<CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com>
	<4F574113.8030906@01019freenet.de>
	<alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
	<CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com>
	<alpine.LNX.2.00.1203121329430.18356@pobox.suse.cz>
	<CAFLxGvyXwFwLRYw7=eHGLZsiAB9Adcu16z=UPhLtL_Ze3bF-9g@mail.gmail.com>
	<alpine.LNX.2.00.1203121402460.18356@pobox.suse.cz>
Date: Mon, 12 Mar 2012 22:38:43 +0100
Message-ID: <CAFLxGvzu7EGePp=B_jf+8O2O-6Q5VFUoFW29GkEQd0aCgriu+A@mail.gmail.com>
Subject: Re: Corrupted files after suspend to disk
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 2:03 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 12 Mar 2012, richard -rw- weinberger wrote:
>
>> >> > This is happening to me as well. Something like 1 resume out of 5 goes
>> >> > wrong this very same way.
>> >> >
>> >> > This is thinkpad x200s.
>> >> >
>> >> > All the userspace is segfaulting all over the place (most frequently in
>> >> > libselinux for some reason).
>> >> >
>> >> > I am not able to verify the 'drop_caches' theory, as I can't invoke a
>> >> > single command that wouldn't crash.
>> >>
>> >> The question is how should we proceed?
>> >> I've reported this issue one year (!!!) ago.
>> >
>> > Hmm, 3.3-rcX seems to be the first version when it started to happen to
>> > me. I take it that you have seen this also with 3.2? 3.1?
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

Yes.
But I don't think that the issue is related to it.
Because Andreas doesn't have a Thinkpad.

-- 
Thanks,
//richard
