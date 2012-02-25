Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab2BYXoD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 18:44:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35856 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2BYXoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 18:44:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jidong.xiao@gmail.com designates 10.14.184.3 as permitted sender) smtp.mail=jidong.xiao@gmail.com; dkim=pass header.i=jidong.xiao@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120225205540.GA29303@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	<CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
	<20120224153811.GA16535@kroah.com>
	<CAG4AFWaDxK2r9W7eehAnWHxD92C_fjpL1OQnENuZFjOjXDOYmA@mail.gmail.com>
	<20120224165448.GA8751@kroah.com>
	<CAG4AFWb3y0GuKnun5Oiw7UEruUSaw78PoSxeyaXAN13o-aDrtw@mail.gmail.com>
	<20120225205540.GA29303@kroah.com>
Date: Sat, 25 Feb 2012 18:43:58 -0500
Message-ID: <CAG4AFWZOJ6_WtU50pZb6zzyBb7CWwphFzt_duyx_WTY45Gt1pw@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 3:55 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Feb 25, 2012 at 02:23:07PM -0500, Jidong Xiao wrote:
>> Hi, Greg,
>>
>> These two studies support my point. If the first one is too old, then
>> the second one should be more convincing. To save your time, you can
>> take a look at their conclusion first.
>>
>> An Empirical Study of Operating Systems Errors
>> http://www.stanford.edu/~engler/metrics-sosp-01.pdf
>>
>> Faults in Linux: Ten Years Later
>> http://pagesperso-systeme.lip6.fr/Suman.Saha/src/asplos11.pdf
>
> This second paper proves my point, it's funny that you tried to use it
> to prove yours, you obviously must not have read the conclusion...
>
> Anyway, any paper that goes "look at all of these problems in the code!"
> and isn't instantly followed by patches fixing ALL of those problems by
> the authors of the paper, should be ignored as a troll masquerading as a
> "study".
>
My point was "a significant portion of kernel crash incidents are due
to bugs in drivers". You said no. I did *not* say bugs in device
drivers are the dominant factor of kernel crashes/faults. So at least
my point matches with the conclusion of the second paper. You can
certainly say these academic studies are meaningless because they are
not telling the whole story, but you can not deny the fact that
because of the large code base, it is the almost impossible to
eliminate all the bugs/problems from device drivers. That's why people
are doing research to mitigate this problem, even though moving device
drivers to user space may not be a good idea, or it is unrealistic in
Linux, those researchers as well as their results deserve more
respect. Everyone in the whole community, including kernel developers
and researchers, shares the same goal, namely, improving the kernel
code quality.

Regards
Jidong
