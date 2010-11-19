Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0KSNHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:07:25 -0500
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:46021 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746Ab0KSNHX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:07:23 -0500
X-AuditID: 1209190e-b7b3bae000000a71-f0-4ce6768ad50b
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <8762vtsbx5.fsf@gmail.com>
Date: Fri, 19 Nov 2010 08:07:12 -0500
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andev <debiandev@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C47257FC-498A-41B0-BC94-C81C72601D53@mit.edu>
References: <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com> <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com> <20101116202839.GC27235@tango.0pointer.de> <20101116205243.64e4a67a@lxorguk.ukuu.org.uk> <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com> <20101116211909.GB16589@tango.0pointer.de> <20101116233934.GC1568@thunk.org> <20101117002159.GA3184@tango.0pointer.de> <20101117020626.GB3290@thunk.org> <AANLkTikLjQZiDcQx7HfgznPgFmYOfaN9of2ZtWLEvno8@mail.gmail.com> <1290167993.2109.1562.camel@laptop> <8762vtsbx5.fsf@gmail.com>
To: Ben Gamari <bgamari.foss@gmail.com>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 19, 2010, at 8:03 AM, Ben Gamari wrote:

>> t means it will become
>> impossible to sanely switch off (gnome firmly believes knobs are evil),
>> leaving everybody who _does_ know wth they're doing up a certain creek
>> without a paddle.
> 
> Please, can we stop with this false dichotomy? This is decidedly not
> true and as Lennart has already pointed out, the knob already exists in
> systemd. You may like the kernel approach, but this does not mean there
> is no place for grouping driven by userspace.

Yes, and then at the next release, some idiotic GNOME engineer will decide to the "improve" the system by removing yet another knob....

-- Ted

