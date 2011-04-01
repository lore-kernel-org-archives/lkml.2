Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1DAJ2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 05:28:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:53106 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab1DAJ2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 05:28:42 -0400
Date: Fri, 1 Apr 2011 11:28:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] x86 idle APM: delete apm_cpu_idle(), and its use of
 pm_idle
In-Reply-To: <alpine.LFD.2.02.1103302311500.2444@x980>
Message-ID: <alpine.LNX.2.00.1104011127480.22712@pobox.suse.cz>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au> <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz> <20110329004438.d9e755ef.sfr@canb.auug.org.au> <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz> <20110328174542.GW21838@one.firstfloor.org>
 <4D90CC0B.8070105@zytor.com> <20110328182123.GX21838@one.firstfloor.org> <AANLkTimqE2YZCH5GonnqeHGGBwzggTymauS1KYuTsqOX@mail.gmail.com> <alpine.LNX.2.00.1103282309290.26754@pobox.suse.cz> <alpine.LFD.2.02.1103302311500.2444@x980>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Len Brown wrote:

> From: Len Brown <len.brown@intel.com>
> 
> There is some doubt whether the APM idle feature
> to call into the BIOS from the idle loop is reliable.
> Certainly it was known to fail on some machines,
> but more importantly, APM machines have not shipped
> for a decade and so finding machines to test the code
> is problematic.
> 
> After this patch, systems running in APM mode will
> simply run default_idle() and HALT without calling
> into the BIOS from their idle loop.
> 
> This deletes a much-maligned modular user of the (pm_idle)()
> function pointer.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
> Jiri,
> If you can review, test, ack, that would be great.
> I'll probably end up shipping this via the idle tree
> because subsequent patches to delete pm_idle
> will depend on it.

Looks fine, works here.

	Acked-by: Jiri Kosina <jkosina@suse.cz>

Thanks Len.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
