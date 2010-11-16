Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab0KPUpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:45:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39291
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754211Ab0KPUpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:45:53 -0500
Date: Tue, 16 Nov 2010 12:46:17 -0800 (PST)
Message-Id: <20101116.124617.200351382.davem@davemloft.net>
To: mzxreary@0pointer.de
Cc: torvalds@linux-foundation.org, dhaval.giani@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, vgoyal@redhat.com,
        oleg@redhat.com, markus@trippelsdorf.de,
        mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101116202839.GC27235@tango.0pointer.de>
References: <20101116181603.GC19327@tango.0pointer.de>
	<AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
	<20101116202839.GC27235@tango.0pointer.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lennart Poettering <mzxreary@0pointer.de>
Date: Tue, 16 Nov 2010 21:28:39 +0100

> Heck, the patch wouldn't even have any effect on my machine (and I am
> hacker), because I tend to run my builds from within emacs. And since
> emacs has no TTY (since it is a X11/gtk build) it wouldn't be in its own
> scheduling group.

Type 'tty' in that emacs shell, what does it give you?

It does get it's own TTY and it will thus get it's own scheduling
group.
