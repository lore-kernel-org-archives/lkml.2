Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1ASTHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:07:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52653 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1ASTHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:07:09 -0500
Message-ID: <4D3735A2.2090806@zytor.com>
Date: Wed, 19 Jan 2011 11:04:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthieu CASTET <castet.matthieu@free.fr>, Lin Ming <ming.m.lin@intel.com>,
        Oliver Neukum <oneukum@suse.de>, rjw@sisk.pl,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Michal Marek <mmarek@suse.cz>, Yinghai Lu <yinghai@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Dave Airlie <airlied@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] S3 resume on SandyBridge doesn't work with NX protection
 (5bd5a45)
References: <20110119173710.GA1331@suse.de>
In-Reply-To: <20110119173710.GA1331@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 09:37 AM, Matthias Hopf wrote:
> Git commit 5bd5a45 in Linus' tree "x86: Add NX protection for kernel data"
> apparently breaks resume on SandyBridge machines. This is supposed to be
> fixed with commit 691513f "x86: Resume trampoline must be executable",
> but even git master (v2.6.38-rc1) shows the same symptoms.
> 
> After suspend to S3, the machine doesn't resume upon wakeup, but boots
> normally instead. Reverting git commits 691513f, 84e1c6b, and especially
> 5bd5a45 (trivial except for a single hunk) makes resume work again.
> 
> lspci -vvv output is attached.
> 
> (for internal reference: machine NUE874)
> 

"Sandy Bridge machines" is not likely to be descriptive.  This is much
more likely to be related to a specific motherboard.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

