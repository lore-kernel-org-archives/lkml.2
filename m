Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab1EaTwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:52:19 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50023 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab1EaTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:52:17 -0400
Date: Tue, 31 May 2011 21:51:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20110531195159.GA17641@aftab>
References: <20110531163022.GA15435@elte.hu>
 <1306859709.20175.27.camel@Joe-Laptop>
 <20110531181650.GA1854@gere.osrc.amd.com>
 <20110531190436.GA22173@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531190436.GA22173@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 03:04:36PM -0400, Ingo Molnar wrote:
> The message itself is exceedingly rare, so we can fix it via lower 
> prio pathways.

Btw, I went and caused it for funsies and I don't think anyone would
concentrate on the one-too-many quotes at the end when she/he sees the
below :>)

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/process.c:645 idle_setup+0x90/0xed()
[    0.000000] "idle=mwait" will be removed in 2012"
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.0.0-rc1+ #72
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8103b63e>] warn_slowpath_common+0x85/0x9d
[    0.000000]  [<ffffffff8103b6f9>] warn_slowpath_fmt+0x46/0x48
[    0.000000]  [<ffffffff81b4ea06>] idle_setup+0x90/0xed
[    0.000000]  [<ffffffff81b48b54>] do_early_param+0x5d/0x89
[    0.000000]  [<ffffffff810559a4>] parse_args+0x17d/0x241
[    0.000000]  [<ffffffff81b48af7>] ? start_kernel+0x2ce/0x2ce
[    0.000000]  [<ffffffff81b484a5>] parse_early_options+0x1e/0x20
[    0.000000]  [<ffffffff81b4881d>] parse_early_param+0x31/0x3d
[    0.000000]  [<ffffffff81b4a9e7>] setup_arch+0x354/0x733
[    0.000000]  [<ffffffff81480999>] ? printk+0x41/0x48
[    0.000000]  [<ffffffff810633b1>] ? clockevents_register_notifier+0x43/0x4f
[    0.000000]  [<ffffffff81b488b8>] start_kernel+0x8f/0x2ce
[    0.000000]  [<ffffffff81b48272>] x86_64_start_reservations+0x82/0x86
[    0.000000]  [<ffffffff81b48363>] x86_64_start_kernel+0xed/0xf4
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
