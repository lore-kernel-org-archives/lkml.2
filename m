Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935060Ab0KQRRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:17:33 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:33860 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935027Ab0KQRRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:17:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19684.3589.497919.669784@quad.stoffel.home>
Date: Wed, 17 Nov 2010 12:16:53 -0500
From: "John Stoffel" <john@stoffel.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
In-Reply-To: <20101117150156.GA17082@tango.0pointer.de>
References: <20101116181603.GC19327@tango.0pointer.de>
	<AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
	<20101116202839.GC27235@tango.0pointer.de>
	<20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
	<AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
	<20101116211909.GB16589@tango.0pointer.de>
	<20101116233934.GC1568@thunk.org>
	<20101117002159.GA3184@tango.0pointer.de>
	<20101117020626.GB3290@thunk.org>
	<20101117145712.GA29892@redhat.com>
	<20101117150156.GA17082@tango.0pointer.de>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Lennart" == Lennart Poettering <mzxreary@0pointer.de> writes:

Lennart> I wouldn't be too concerned here. It's not that we end up
Lennart> with 1000s of groups here. It's way < 40 or in the end, for a
Lennart> single user machine. Which I think isn't that bad.

Ok, so how will this impact users on a single machine which is used to
host VNC sessions?  I've got machines with 30+ users all running one
or more VNC sessions each on there.  Nothing CPU bound generally,
unless something freaks out and starts hogging a CPU.  But will the
overhead of 1000 groups be noticeable?

Thanks,
John
