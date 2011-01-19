Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1ASWGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:06:20 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:56701 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab1ASWGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:06:19 -0500
Date: Wed, 19 Jan 2011 23:06:02 +0100
From: matthieu castet <castet.matthieu@free.fr>
To: Matthias Hopf <mhopf@suse.de>
Cc: Lin Ming <ming.m.lin@intel.com>, Oliver Neukum <oneukum@suse.de>,
        rjw@sisk.pl, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
Subject: Re: [REGRESSION] S3 resume on SandyBridge doesn't work with NX
 protection (5bd5a45)
Message-ID: <20110119230602.6dd34fa3@mat-laptop>
In-Reply-To: <20110119173710.GA1331@suse.de>
References: <20110119173710.GA1331@suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le Wed, 19 Jan 2011 18:37:11 +0100,
Matthias Hopf <mhopf@suse.de> a écrit :

> Git commit 5bd5a45 in Linus' tree "x86: Add NX protection for kernel
> data" apparently breaks resume on SandyBridge machines. This is
> supposed to be fixed with commit 691513f "x86: Resume trampoline must
> be executable", but even git master (v2.6.38-rc1) shows the same
> symptoms.
Is it a 32bit or 64 bit kernel ?

Could you post the dmesg of the kernel.


Matthieu
