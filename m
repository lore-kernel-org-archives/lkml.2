Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab1DBWXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 18:23:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:47728 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab1DBWXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 18:23:06 -0400
Date: Sun, 3 Apr 2011 00:23:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Carsten Emde <C.Emde@osadl.org>
cc: Mike Galbraith <efault@gmx.de>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Asit Mallick <asit.k.mallick@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.33.8
In-Reply-To: <4D96E90D.9000905@osadl.org>
Message-ID: <alpine.LFD.2.00.1104030019260.5929@localhost6.localdomain6>
References: <20110321204104.GA2702@kroah.com>  <4D94C666.3060206@osadl.org> <1301632555.4766.5.camel@marge.simson.net> <4D96E90D.9000905@osadl.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Apr 2011, Carsten Emde wrote:
> This is the situation:
> 
> 1. Without commit ea53069231f9317062910d6e772cca4ce93de8c8:
> Everyting is fine. The system correctly powers off.
> 
> 2. With commit ea53069231f9317062910d6e772cca4ce93de8c8:
>    a) Frequency scaling never enabled (acpi_cpufreq not loaded,
>       cpufreq_ondemand not loaded):
>       Everything is fine. The system correctly powers off.
>    b) Frequency scaling enabled (acpi_cpufreq loaded, cpufreq_ondemand
>       loaded) or
>    c) Frequency scaling enabled and disabled (acpi_cpufreq still loaded
>       since it cannot be removed easily, cpufreq_ondemand no longer
>       loaded) or
>    d) Frequency scaling enabled and disabled (acpi_cpufreq unloaded
>       with force, cpufreq_ondemand no longer loaded):
>       Not powering off, message:
>       ACPI: Preparing to enter system sleep state S5
>       Disabling non-boot CPUs ...

Could any of the intel folks please add their input on that? I'm
running out of ideas.

Thanks,

	tglx

