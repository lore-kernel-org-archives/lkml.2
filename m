Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1DKTYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 15:24:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36397 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754455Ab1DKTYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 15:24:12 -0400
Date: Mon, 11 Apr 2011 20:24:09 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 1/5] signals: Always place SIGCONT and SIGSTOP on
 'shared_pending'
Message-ID: <20110411202409.07b804e5@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110411185005.GA4240@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
	<1302031310-1765-2-git-send-email-matt@console-pimps.org>
	<20110405201958.GA1404@redhat.com>
	<20110405215003.636e950b@mfleming-mobl1.ger.corp.intel.com>
	<20110406125757.GA12099@redhat.com>
	<20110406141548.1e0736ce@mfleming-mobl1.ger.corp.intel.com>
	<20110411185005.GA4240@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 20:50:05 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Sorry for delay again. I'll try to read the rest of this series
> tomorrow, I can no longer look at signal.c to today.

No problem.

> Oh, these changes do not look trivial. I must admit, I am a bit
> sceptical, but this is only my first impression based on amount on
> changes and more complex locking.

Yeah, the locking is more complex and I suspect that because I'm
dropping this patch the next iteration might become even more complex.
However, I definitely think the complexity is worth it because of how
much better signal delivery scales with these patches.

If you find anything that you think is overly complex I'm sure I could
clean it up with either comments or refactoring the code.

-- 
Matt Fleming, Intel Open Source Technology Center
