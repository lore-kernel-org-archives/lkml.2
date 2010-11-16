Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab0KPVOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:14:53 -0500
Received: from tango.0pointer.de ([85.214.72.216]:53833 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab0KPVOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:14:52 -0500
Date: Tue, 16 Nov 2010 22:14:31 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@lang.hm, Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116211431.GA15211@tango.0pointer.de>
References: <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <alpine.DEB.2.00.1011161058180.3718@asgard.lang.hm>
 <20101116203306.GE27235@tango.0pointer.de>
 <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 12:38, Linus Torvalds (torvalds@linux-foundation.org) wrote:

> 
> On Tue, Nov 16, 2010 at 12:33 PM, Lennart Poettering
> <mzxreary@0pointer.de> wrote:
> >
> > No you don't. Because that is not a desktop use case.
> 
> See my other response. You don't care AT ALL, because by your
> judgement, all desktop is is a web browser and a word processor.

Well, I do care. But I care more about *real* problems. For example the
fact that "updatedb" makes your system sluggish while it runs. Or
"man-db". Or anything else that runs from cron in the background.

Doing this tty dance won't help you much with background tasks such as
man-db, updatedb and cron and its jobs, will it? They don't have
ttys. Sorry for you. meh! Meh! meh! meh! meh!

(And along comes systemd, which actually handles this properly, since it
actually has a proper notion of what a service is, and what a session
is, and what an app is. And which hence can control all this sanely.)

Binding this to a tty is just solves a tiny bit of the real problem:
i.e. your own use of make -j. End of story.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
