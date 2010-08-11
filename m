Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0HKOHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:07:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:59752 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab0HKOHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:07:32 -0400
Message-ID: <4C62AE89.1090909@windriver.com>
Date: Wed, 11 Aug 2010 09:07:05 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/2] rcu,debug_core: allow the kernel debugger to
 reset the rcu stall timer
References: <1281330732-17164-1-git-send-email-jason.wessel@windriver.com> <1281330732-17164-2-git-send-email-jason.wessel@windriver.com> <1281330732-17164-3-git-send-email-jason.wessel@windriver.com> <20100809174353.GH3026@linux.vnet.ibm.com> <4C60484B.8030002@windriver.com> <20100809190142.GM3026@linux.vnet.ibm.com> <20100811040157.GA7722@linux.vnet.ibm.com>
In-Reply-To: <20100811040157.GA7722@linux.vnet.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2010 14:07:03.0898 (UTC) FILETIME=[7989E3A0:01CB395E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 11:01 PM, Paul E. McKenney wrote:
> On Mon, Aug 09, 2010 at 12:01:42PM -0700, Paul E. McKenney wrote:
> 
> Here is an initial patch.  Untested, probably doesn't even compile.
> It is against my -rcu tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing
> 
> Thoughts?
> 


Paul, I tried this out and code wise it looks fine to me. I performed
a compile and regression test with the various kernel config options
to cover this new code.

Thanks for fixing the rcu_preempt case that my original patch missed.
Because you used the same name for the function it was an easy drop in
replacement.  :-)

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

Cheers,
Jason.
