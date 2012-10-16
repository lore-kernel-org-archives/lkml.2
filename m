Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2JPTkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:40:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53247 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab2JPTkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:40:47 -0400
Date: Tue, 16 Oct 2012 21:40:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v9 03/12] x86, topology: Don't offline CPU0 if any PIC
 irq can not be migrated out of it
Message-ID: <20121016194044.GB27090@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Yu, Fenghua" <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Arjan Dan De Ven <arjan@linux.intel.com>,
	"Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	"Brown, Len" <len.brown@intel.com>,
	"Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Chen Gong <gong.chen@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
 <1350058189-6769-4-git-send-email-fenghua.yu@intel.com>
 <20121016170310.GC12694@x1.osrc.amd.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122030B16447@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122030B16447@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 06:43:36PM +0000, Yu, Fenghua wrote:
> arch/x86/kernel/cpu/topology.c doesn't contain CPU hotplug hooks.
> To place the BSP patchset in this file, other existing CPU hotplug
> code should be moved to this file as well. Apparently that's not this
> patchset's task.

Right, ok.

But looking at this a bit more, we (someone :)) should probably merge
those two files together since both deal with the cpu aspect of
topology...

Oh well.

-- 
Regards/Gruss,
    Boris.
