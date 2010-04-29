Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab0D3Ro6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:44:58 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47146 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757647Ab0D3Ros (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:44:48 -0400
Date: Thu, 29 Apr 2010 17:10:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Howells <dhowells@redhat.com>,
       Peter Fritzsche <peter.fritzsche@gmx.de>
Cc: Jamie Lokier <jamie@shareable.org>, Arnd Bergmann <arnd@arndb.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Keith M Wesolowski <wesolows@foobazco.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/2] asm-generic: Don't warn that atomic_t is only 24
	bit
Message-ID: <20100429211035.GA16179@Krystal>
References: <20100428162708.GB2846@Krystal> <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de> <1272453036-18670-1-git-send-email-peter.fritzsche@gmx.de> <201004281533.29327.arnd@arndb.de> <20100428135434.GA4662@Krystal> <20100428152815.GB25569@shareable.org> <22809.1272558128@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22809.1272558128@redhat.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:09:38 up 96 days, 23:46,  9 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Howells (dhowells@redhat.com) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > How about simply replacing arch/mn10300/include/asm/atomic.h by:
> > 
> > arch/mn10300/include/asm/atomic.h:
> > #include <asm-generic/atomic.h>
> > 
> > ?
> > 
> > This should have been done a while ago. They are almost the same, except for
> > added cmpxchg*_local() in the asm-generic version (which would benefit to
> > mn10300).
> 
> Fine by me.

Then I'll let Peter Fritzsche deal with that. I don't want to conflict with his
current patches.

Thanks,

Mathieu

> 
> David

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
