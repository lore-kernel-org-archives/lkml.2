Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2CLMXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:23:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36112 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2CLMXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:23:52 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
References: <201202162251.47063.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1202161722310.1150-100000@iolanthe.rowland.org>
	<CAFLxGvwWBWTmv+uUH87UB3Ly31hjVU5kWpSyihGDKj6_8oc6WA@mail.gmail.com>
	<201202170016.14313.rjw@sisk.pl>
	<jj5qhh$5j5$1@ID-44327.news.uni-berlin.de>
	<jj684d$6ng$1@ID-44327.news.uni-berlin.de>
	<CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com>
	<4F574113.8030906@01019freenet.de>
	<alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
Date: Mon, 12 Mar 2012 13:23:50 +0100
Message-ID: <CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com>
Subject: Re: Corrupted files after suspend to disk
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 1:03 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 7 Mar 2012, Andreas Hartmann wrote:
>
>> > On my system kernel suspend *seems* to work.
>> > I've seen no corrupted files so far.
>> >
>> > But sometimes the resume is failing. (One out of 5 resumes fails).
>> > I was unable to get any kernel output.
>> >
>> > So I'm not sure whether this is the same issue
>> > or another one. :-\
>>
>> I'm pretty sure that this is the same issue. What you are telling
>> correlates with my research here.
>> I even got resumes where the machine came up again, but nothing could be
>> done (it wasn't possible to switch of the password secured screen saver
>> any more - login at the shell wasn't possible, too, because the started
>> bash crashed),
>
> This is happening to me as well. Something like 1 resume out of 5 goes
> wrong this very same way.
>
> This is thinkpad x200s.
>
> All the userspace is segfaulting all over the place (most frequently in
> libselinux for some reason).
>
> I am not able to verify the 'drop_caches' theory, as I can't invoke a
> single command that wouldn't crash.

The question is how should we proceed?
I've reported this issue one year (!!!) ago.

-- 
Thanks,
//richard
