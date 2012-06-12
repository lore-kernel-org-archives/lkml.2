Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2FLJTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:19:15 -0400
Received: from ozlabs.org ([203.10.76.45]:52318 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab2FLJTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:19:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] kthread: Implement park/unpark facility
In-Reply-To: <alpine.LFD.2.02.1206111124110.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1206042203590.3086@ionos> <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au> <alpine.LFD.2.02.1206051135260.3086@ionos> <alpine.LFD.2.02.1206051538280.3086@ionos> <878vfviv1h.fsf@rustcorp.com.au> <alpine.LFD.2.02.1206111124110.3086@ionos>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 12 Jun 2012 09:53:42 +0930
Message-ID: <873961pecx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012 11:26:12 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> Makes sense. Will have a go on that.
> 
> One other thing what I'm thinking about is to avoid the synchronous
> parking mechanism, i.e. just tell the thread to park and check the
> park state later before going further down.

Yes, definitely a nice optimization, and should be pretty simple.

Thanks,
Rusty.
