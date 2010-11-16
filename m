Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab0KPVOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:14:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46816
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696Ab0KPVOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:14:08 -0500
Date: Tue, 16 Nov 2010 13:14:31 -0800 (PST)
Message-Id: <20101116.131431.258095605.davem@davemloft.net>
To: mzxreary@0pointer.de
Cc: torvalds@linux-foundation.org, dhaval.giani@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, vgoyal@redhat.com,
        oleg@redhat.com, markus@trippelsdorf.de,
        mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101116210804.GJ27235@tango.0pointer.de>
References: <20101116202839.GC27235@tango.0pointer.de>
	<20101116.124617.200351382.davem@davemloft.net>
	<20101116210804.GJ27235@tango.0pointer.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lennart Poettering <mzxreary@0pointer.de>
Date: Tue, 16 Nov 2010 22:08:04 +0100

> On Tue, 16.11.10 12:46, David Miller (davem@davemloft.net) wrote:
> 
>> 
>> From: Lennart Poettering <mzxreary@0pointer.de>
>> Date: Tue, 16 Nov 2010 21:28:39 +0100
>> 
>> > Heck, the patch wouldn't even have any effect on my machine (and I am
>> > hacker), because I tend to run my builds from within emacs. And since
>> > emacs has no TTY (since it is a X11/gtk build) it wouldn't be in its own
>> > scheduling group.
>> 
>> Type 'tty' in that emacs shell, what does it give you?
> 
> I am running "make -j", not a shell from emacs. it doesn't have a tty.
> 
> I just want to build something, not have terminal emulator in emacs.

It does the same exact thing.  Please actually check and verify
your facts instead of tossing back kneejerk responses.

davem@sunset:~/src/GIT$ cat Makefile
all:
	tty
davem@sunset:~/src/GIT$ 

"M-x compile" in that directory gives:

--------------------
-*- mode: compilation; default-directory: "~/src/GIT/" -*-
Compilation started at Tue Nov 16 13:13:01

make -k 
tty
/dev/pts/2

Compilation finished at Tue Nov 16 13:13:01
--------------------

