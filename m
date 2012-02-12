Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2BLXLD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 18:11:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab2BLXLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 18:11:01 -0500
From: Thomas Renninger <trenn@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>, gregkh@linuxfoundation.org
Subject: Re: [PATCH 0/5] Clean up x86 CPU auto-loading
Date: Mon, 13 Feb 2012 00:10:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org,
        Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
References: <1329000256.325.48.camel@deadeye>
In-Reply-To: <1329000256.325.48.camel@deadeye>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201202130010.57492.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 February 2012 23:44:16 Ben Hutchings wrote:
> This series fixes a number of apparent bugs in the recent changes to
> enable auto-loading by x86 CPU ID.

These all look correct.
I should have spotted the intel_idle modifications myself.
Good catch(es).

Greg: I expect these should get queued in your driver-core-next branch?

Thanks,

    Thomas
> 
> Ben.
> 
> Ben Hutchings (5):
>   x86/cpu: Fix overrun check in arch_print_cpu_modalias()
>   x86/cpu: Clean up modalias feature matching
>   intel_idle: Fix ID for Nehalem-EX Xeon in device ID table
>   intel_idle: Revert change of auto_demotion_flags for Nehalem
>   powernow-k7: Fix CPU family number
> 
>  arch/x86/kernel/cpu/match.c   |    5 ++---
>  drivers/cpufreq/powernow-k7.c |    2 +-
>  drivers/idle/intel_idle.c     |   12 ++++--------
>  scripts/mod/file2alias.c      |    5 +++--
>  4 files changed, 10 insertions(+), 14 deletions(-)
> 
> -- 
> 1.7.9
> 
> 
> 

