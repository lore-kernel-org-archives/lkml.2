Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1DNV5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:57:06 -0400
Received: from kroah.org ([198.145.64.141]:52091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab1DNV5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:57:03 -0400
Date: Thu, 14 Apr 2011 14:56:56 -0700
From: Greg KH <greg@kroah.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Stable <stable@kernel.org>, John Kacur <jkacur@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [stable] [PATCH V4] futex: set FLAGS_HAS_TIMEOUT during demux
 for FUTEX_WAIT
Message-ID: <20110414215656.GB14169@kroah.com>
References: <ef361f98ac0e0771c14ec7facb5b41086eb4ba50.1302817381.git.dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef361f98ac0e0771c14ec7facb5b41086eb4ba50.1302817381.git.dvhart@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 02:43:01PM -0700, Darren Hart wrote:
> The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
> restart futex_wait() without a timeout after a signal.
> 
> Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
> removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
> of the restart block. Restore the originaly behavior.
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922
> 
> V2: Added references to commit message.
> V3: Set flag during restart block instead of do_futex()
> V4: Correct stupid order of assignment mistake pointed out by Eric
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Reported-by: Tim Smith <tsmith201104@yahoo.com>
> Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: John Kacur <jkacur@redhat.com>
> ---

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

thanks,

greg k-h
