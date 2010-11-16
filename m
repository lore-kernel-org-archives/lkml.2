Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0KPT1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:27:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49534 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab0KPT12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:27:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WM5e8Yn570yBs/dsqL5EcHOP+eTvUNRnXXnaIsQHYcKGM6+3R+1imMSHGAScZOFlUc
         bOOB0n3bz9Iyz6m9bW9Keulu9Y0ClWbTUgyRUGLekVKAdDTR3FOLDnjlaVoqF/rRkQAo
         yb+wBFhiKVbjgjfCAcvDisRtvmWrg38U/3HyU=
MIME-Version: 1.0
In-Reply-To: <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
References: <1289820766.16406.45.camel@maggy.simson.net>
	<1289821590.16406.47.camel@maggy.simson.net>
	<20101115125716.GA22422@redhat.com>
	<1289856350.14719.135.camel@maggy.simson.net>
	<20101116015648.GA11534@redhat.com>
	<1289916171.5169.117.camel@maggy.simson.net>
	<1289916683.2109.625.camel@laptop>
	<AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
	<20101116170312.GA19327@tango.0pointer.de>
	<AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	<20101116181603.GC19327@tango.0pointer.de>
	<AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
Date: Tue, 16 Nov 2010 20:27:27 +0100
Message-ID: <AANLkTikjQKmo0j5xbvPiS=eriAUUZPMGKkcxt8w_z8XB@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 7:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Nov 16, 2010 at 10:16 AM, Lennart Poettering
> <mzxreary@0pointer.de> wrote:
>>
>> Here's my super-complex patch btw, to achieve exactly the same thing
>> from userspace without involving any kernel or systemd patching and
>> kernel-side logic. Simply edit your own ~/.bashrc and add this to the end:
>
> Right. And that's basically how this "patch" was actually tested
> originally - by doing this by hand, without actually having a patch in
> hand. I told people: this seems to work really well. Mike made it work
> automatically.
>
> Because it's something we want to do it for all users, and for all
> shells, and make sure it gets done automatically. Including for users
> that have old distributions etc, and make it easy to do in one place.
> And then you do it for all the other heuristics we can see easily in
> the kernel. And then you do it magically without users even having to
> _notice_.
>

So what do you think about something like systemd handling it. systemd
already does a lot of this stuff already in the form of process
tracking, so it is quite trivial to do this. And more happily avoids
all this complexity in the kernel.

Thanks,
Dhaval
