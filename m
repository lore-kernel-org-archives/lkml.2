Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0EQWhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:37:21 -0400
Received: from www.tglx.de ([62.245.132.106]:36237 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab0EQWhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:37:20 -0400
Date: Tue, 18 May 2010 00:36:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
In-Reply-To: <a3572531-ca89-4959-b190-bcb9309a0193@default>
Message-ID: <alpine.LFD.2.00.1005180022040.3368@localhost.localdomain>
References: <87tyq9mqrz.fsf@basil.nowhere.org> <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default 20100517102214.GA20761@basil.fritz.box> <a3572531-ca89-4959-b190-bcb9309a0193@default>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010, Dan Magenheimer wrote:
> 
> OK, so let's invert the sense of the sysfs file and call it (for now)
> "tsc_detected_as_UNreliable".  Then anytime the kernel detects
> a failed warp test (or any other suspicious condition), it changes
> the bit from 0 to 1 effectively saying "if you are using rdtsc
> against our recommendation, we told you that it might go bad and
> it has, so consider yourself warned that some of the timestamps
> you've taken since the last time you've checked this flag
> may be b*rked"
> 
> IMHO, addressing the issue directly and clearly documenting it
> (instead of trying to hide the dirty laundry in the kernel)
> will result in far better education of systems programmers
> and far fewer end user problems. Which raises another good analogy:
> 
> You are telling teenagers to abstain and I am proposing that we
> instead encourage them to use a condom.

Wrong. A vsyscall _is_ the protection which you want them to pull over
the rdtsc.

You are basically telling them: Go ahead, but keep in mind to look for
that well hidden tag behind the left earlobe which might change
suddenly from "no disease" to "infectous".

Thanks,

	tglx
