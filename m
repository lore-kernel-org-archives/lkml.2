Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2CLNii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:38:38 -0400
Received: from mout6.freenet.de ([195.4.92.96]:57135 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab2CLNih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:38:37 -0400
Message-ID: <4F5DFBD5.90205@01019freenet.de>
Date: Mon, 12 Mar 2012 14:36:21 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Firefox/10.0.2 SeaMonkey/2.7.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: Corrupted files after suspend to disk
References: <201202162251.47063.rjw@sisk.pl> <Pine.LNX.4.44L0.1202161722310.1150-100000@iolanthe.rowland.org> <CAFLxGvwWBWTmv+uUH87UB3Ly31hjVU5kWpSyihGDKj6_8oc6WA@mail.gmail.com> <201202170016.14313.rjw@sisk.pl> <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de> <jj684d$6ng$1@ID-44327.news.uni-berlin.de> <CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com> <4F574113.8030906@01019freenet.de> <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina schrieb:
> On Wed, 7 Mar 2012, Andreas Hartmann wrote:
> 
>>> On my system kernel suspend *seems* to work.
>>> I've seen no corrupted files so far.
>>>
>>> But sometimes the resume is failing. (One out of 5 resumes fails).
>>> I was unable to get any kernel output.
>>>
>>> So I'm not sure whether this is the same issue
>>> or another one. :-\
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

I'm checking after every resume for broken files (via md5sum check). If
you are lucky, only irrelevant files are damaged.

But you are right, with 3.2 (or was it 3.3?), the drop_caches theory
doesn't work at all for me (if it isn't by chance).


Regards,
Andreas
