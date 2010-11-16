Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab0KPUoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:44:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44452 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab0KPUob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:44:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=KySXb5YzK4rIo7LbHGcX63cHoWtfH9PPj/leSOdor2z3SoFwMTNTQSvIg1TVlh0bWU
         K5d0vZB1g+zaVlb8ciJqJxitXtiOgDW+OK0a4ECnPLhHEY9/CGgAOrwSgINAUIhZheea
         GBeTM1d9w160p055cEwa2JdIfJ0zYrKpCiSd0=
MIME-Version: 1.0
In-Reply-To: <20101116203306.GE27235@tango.0pointer.de>
References: <1289856350.14719.135.camel@maggy.simson.net>
	<20101116015648.GA11534@redhat.com>
	<1289916171.5169.117.camel@maggy.simson.net>
	<1289916683.2109.625.camel@laptop>
	<AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
	<20101116170312.GA19327@tango.0pointer.de>
	<AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	<20101116181603.GC19327@tango.0pointer.de>
	<AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
	<alpine.DEB.2.00.1011161058180.3718@asgard.lang.hm>
	<20101116203306.GE27235@tango.0pointer.de>
Date: Tue, 16 Nov 2010 22:44:29 +0200
X-Google-Sender-Auth: sm-izZkoOGA4FQALmKJCLjx01QI
Message-ID: <AANLkTinCPcc8goO_XoJ_DSwbJGOxni_8xOu8Vo+epqCN@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Pekka Enberg <penberg@kernel.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
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

On Tue, 16.11.10 11:08, david@lang.hm (david@lang.hm) wrote:
>> >If the choice is between telling everybody "you should do this", and
>> >"we should just do this for you", I'll take the second one every time.
>> >We know it should be done. Why should we then tell somebody else to do
>> >it for us?
>>
>> this is good for desktop interactivity because it no longer treats
>> all processes equally, it give more CPU to processes that are
>> running 'stand-alone' then it will to processes that are forked off
>> from one master process.

On Tue, Nov 16, 2010 at 10:33 PM, Lennart Poettering
<mzxreary@0pointer.de> wrote:
> This isn#t good for desktop interatctivey. It is *irrelevant* for
> desktop interactivity -- unless you define running "make -j" a typical
> desktop usecase. Which it isn't.
>
> Just stop bringing about the word "desktop" here. It has no point in
> this discussion.
>
>> In the desktop case where you really want something like 'make -j64'
>
> No you don't. Because that is not a desktop use case.

How about you stop bringing *your* narrow definition of "desktop" to
the discussion? I am a kernel hacker but that doesn't mean I'm not
also a desktop user. I shouldn't need to play with cgroups from
userspace to keep music playing while I compile kernels. Things should
just work.

                        Pekka
