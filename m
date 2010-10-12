Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab0JLQ5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:57:17 -0400
Received: from www.tglx.de ([62.245.132.106]:44930 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab0JLQ5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:57:15 -0400
Date: Tue, 12 Oct 2010 18:56:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Marcio Saito <marcio@cyclades.com>, John Stultz <johnstul@us.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, jblunck@infradead.org
Subject: Re: [RFC] [PATCH] allow low HZ values?
In-Reply-To: <871v7v32kn.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.2.00.1010121854430.2909@localhost6.localdomain6>
References: <20101011201121.GA953@tpepper-t61p.dolavim.us> <alpine.LFD.2.00.1010112227190.2909@localhost6.localdomain6> <871v7v32kn.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Andi Kleen wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> > We have told HPC folks for years that we need a kind of "NOHZ" mode
> > for HPC where we can transparently switch off the tick when only one
> > user space bound thread is active and switch back to normal once this
> > thing terminates or goes into the kernel via a syscall. Sigh, nothing
> > happened ever except for repeating the same crap patches over and
> > over.
> 
> Jan Blunck posted a patch for this exactly few months ago.
> Unfortunately it didn't get the accounting right, but other than
> that it seemed like a reasonable starting point.

Unfortunately it did not get a lot of other things right either.

Thanks,

	tglx
