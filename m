Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0KPUjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:39:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613Ab0KPUjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:39:05 -0500
MIME-Version: 1.0
In-Reply-To: <20101116203306.GE27235@tango.0pointer.de>
References: <1289856350.14719.135.camel@maggy.simson.net> <20101116015648.GA11534@redhat.com>
 <1289916171.5169.117.camel@maggy.simson.net> <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <alpine.DEB.2.00.1011161058180.3718@asgard.lang.hm> <20101116203306.GE27235@tango.0pointer.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 12:38:11 -0800
Message-ID: <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: david@lang.hm, Dhaval Giani <dhaval.giani@gmail.com>,
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

On Tue, Nov 16, 2010 at 12:33 PM, Lennart Poettering
<mzxreary@0pointer.de> wrote:
>
> No you don't. Because that is not a desktop use case.

See my other response. You don't care AT ALL, because by your
judgement, all desktop is is a web browser and a word processor.

So why are you even discussing this? It's irrelevant for you. cgroups
will _never_ matter for what you are talking about, and that has
nothing to do with ttys, automation, scripting or anything else.

Because your definition of "desktop" seems to be "only interactive
apps". So this i all irrelevant.

Which is fine by me. It's not what the patch is supposed to affect.

                         Linus
