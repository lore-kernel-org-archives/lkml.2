Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0KPVR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:17:56 -0500
Received: from tango.0pointer.de ([85.214.72.216]:53871 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab0KPVRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:17:55 -0500
Date: Tue, 16 Nov 2010 22:17:35 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
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
Message-ID: <20101116211735.GA16589@tango.0pointer.de>
References: <20101116015648.GA11534@redhat.com>
 <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <20101116202839.GC27235@tango.0pointer.de>
 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 20:52, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:

> 
> > Well, if I make behaviour like this default in systemd, then this means
> > there won't be user setup for this. Because the distros shipping systemd
> > will get this as default behaviour.
> 
> And within the desktop where would you put this - in the window manager
> on the basis of top level windows or in the app startup ?

The plan with systemd is to make it manage both the system and the
sessions. It's along the lines of what launchd does on MacOS: one
instance for the system, another one for the user, because starting and
supervising a system service and a session service are actually very
very similar things.

In F15 we'll introduce systemd as an init system only. The next step
will be to make it manage sessions too, and replace/augment
gnome-session.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
