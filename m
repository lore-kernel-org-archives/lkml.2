Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab0KPUd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:33:29 -0500
Received: from tango.0pointer.de ([85.214.72.216]:41398 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0KPUd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:33:26 -0500
Date: Tue, 16 Nov 2010 21:33:06 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116203306.GE27235@tango.0pointer.de>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011161058180.3718@asgard.lang.hm>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 11:08, david@lang.hm (david@lang.hm) wrote:

> >If the choice is between telling everybody "you should do this", and
> >"we should just do this for you", I'll take the second one every time.
> >We know it should be done. Why should we then tell somebody else to do
> >it for us?
> 
> this is good for desktop interactivity because it no longer treats
> all processes equally, it give more CPU to processes that are
> running 'stand-alone' then it will to processes that are forked off
> from one master process.

This isn#t good for desktop interatctivey. It is *irrelevant* for
desktop interactivity -- unless you define running "make -j" a typical
desktop usecase. Which it isn't.

Just stop bringing about the word "desktop" here. It has no point in
this discussion.

> In the desktop case where you really want something like 'make -j64'

No you don't. Because that is not a desktop use case.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
