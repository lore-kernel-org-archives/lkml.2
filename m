Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab1LFNA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:00:26 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59066 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab1LFNAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:00:25 -0500
Date: Tue, 6 Dec 2011 14:00:20 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Fenghua Yu <fenghua.yu@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@amd64.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Message-ID: <20111206130020.GB28735@gere.osrc.amd.com>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu>
 <20111206085816.GA11116@elte.hu>
 <4EDDE5D0.7030906@linux.vnet.ibm.com>
 <20111206103500.GD15966@elte.hu>
 <4EDDF2DE.7020701@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDDF2DE.7020701@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 04:17:58PM +0530, Srivatsa S. Bhat wrote:
> In this case, the other patch that I mentioned in my previous mail
> would be required (or an equivalent), because the optimization
> patch which is now in mainline, would apply the same old microcode
> image on this new CPU too, blindly.

Not blindly, the microcode is still verified.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
