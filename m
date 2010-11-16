Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab0KPVI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:08:26 -0500
Received: from tango.0pointer.de ([85.214.72.216]:33925 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab0KPVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:08:25 -0500
Date: Tue, 16 Nov 2010 22:08:04 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, dhaval.giani@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, vgoyal@redhat.com,
        oleg@redhat.com, markus@trippelsdorf.de,
        mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116210804.GJ27235@tango.0pointer.de>
References: <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <20101116202839.GC27235@tango.0pointer.de>
 <20101116.124617.200351382.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116.124617.200351382.davem@davemloft.net>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 12:46, David Miller (davem@davemloft.net) wrote:

> 
> From: Lennart Poettering <mzxreary@0pointer.de>
> Date: Tue, 16 Nov 2010 21:28:39 +0100
> 
> > Heck, the patch wouldn't even have any effect on my machine (and I am
> > hacker), because I tend to run my builds from within emacs. And since
> > emacs has no TTY (since it is a X11/gtk build) it wouldn't be in its own
> > scheduling group.
> 
> Type 'tty' in that emacs shell, what does it give you?

I am running "make -j", not a shell from emacs. it doesn't have a tty.

I just want to build something, not have terminal emulator in emacs.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
