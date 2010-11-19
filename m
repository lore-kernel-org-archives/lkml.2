Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab0KSFUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 00:20:47 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63047 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0KSFUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 00:20:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=VOdgoTkuJN73EVe4HrNtfOMcDplyviLEtfedeGZBk2bOdWZ2B3knVqlFLDTJEn7hrf
         b6ppU7T0+BI7M3cXkFPHe8YaJCeeNsnojeefj0z/FoaTgd48Eq647wpQ3CKyVl2Un/hy
         0DtwbYGHrd5j/Lqb3P/ufLaI2nrGZvjxAI5so=
MIME-Version: 1.0
In-Reply-To: <20101117020626.GB3290@thunk.org>
References: <20101116170312.GA19327@tango.0pointer.de>
	<AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	<20101116181603.GC19327@tango.0pointer.de>
	<AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
	<20101116202839.GC27235@tango.0pointer.de>
	<20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
	<AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
	<20101116211909.GB16589@tango.0pointer.de>
	<20101116233934.GC1568@thunk.org>
	<20101117002159.GA3184@tango.0pointer.de>
	<20101117020626.GB3290@thunk.org>
Date: Fri, 19 Nov 2010 00:20:45 -0500
Message-ID: <AANLkTikLjQZiDcQx7HfgznPgFmYOfaN9of2ZtWLEvno8@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Andev <debiandev@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 9:06 PM, Ted Ts'o <tytso@mit.edu> wrote:

>
> That works for me.  One suggestion is that in addition to "opt-out",
> it should be also possible for an application launcher file to specify
> a specific cgroup name that should be used.  That would allow multiple
> applications in a group to assigned to the same cgroup.

+1 for implementing this in systemd than in the kernel.

The userspace has much more info about which process needs to go into
which group.
