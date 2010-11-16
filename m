Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab0KPUGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:06:08 -0500
Received: from tango.0pointer.de ([85.214.72.216]:40503 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab0KPUGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:06:06 -0500
Date: Tue, 16 Nov 2010 21:05:46 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116200546.GB27235@tango.0pointer.de>
References: <1289820766.16406.45.camel@maggy.simson.net>
 <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com>
 <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com>
 <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <1289930934.2109.644.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289930934.2109.644.camel@laptop>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 19:08, Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:

> 
> On Tue, 2010-11-16 at 18:03 +0100, Lennart Poettering wrote:
> > Binding something like this to TTYs is just backwards. No graphical
> > session has a TTY attached anymore. And there might be multiple TTYs
> > used in the same session. 
> 
> Using a group per tty makes sense for us console jockeys..

Well, then maybe you shouldn't claim this was relevant for anybody but
yourself. Because it is irrelevant for most users if it is bound to the TTY.

> Anyway, nobody uses systemd yet and afaik not all distro's even plan on
> using it (I know I'm not waiting to learn yet another init variant).

Well, the way it looks right now we have convinced all big distros.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
