Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab1KBSa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:30:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:55990 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab1KBSaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:30:55 -0400
Date: Wed, 2 Nov 2011 19:30:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Simon Kirby <sim@hostway.ca>
cc: David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: Linux 3.1-rc9
In-Reply-To: <20111102182812.GE5971@hostway.ca>
Message-ID: <alpine.LFD.2.02.1111021929310.2829@ionos>
References: <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos> <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins> <20111018182046.GF1309@hostway.ca> <alpine.LFD.2.02.1110182146440.3240@ionos>
 <20111024190203.GA24410@hostway.ca> <20111025202049.GB25043@hostway.ca> <20111031173246.GA10614@hostway.ca> <alpine.LFD.2.02.1111021725550.2829@ionos> <20111102182812.GE5971@hostway.ca>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011, Simon Kirby wrote:
> On Wed, Nov 02, 2011 at 05:40:53PM +0100, Thomas Gleixner wrote:
> Ok, I'll try this. Hmm, all CPUs typically try to grab the lock fairly
> quickly after it happens, which could make it difficult to cat the file.
> I'll try ftrace_dump(DUMP_ALL); in there instead.

Eric has spotted the source of trouble already. Can you try his patch
first? If it still persists, we still can resort to hardcore tracing :)

Thanks,

	tglx
