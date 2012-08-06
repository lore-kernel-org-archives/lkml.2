Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2HFPj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:39:58 -0400
Received: from mail.x86-64.org ([217.9.48.20]:57106 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447Ab2HFPj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:39:57 -0400
Date: Mon, 6 Aug 2012 17:39:54 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/4] x86, CPU: Extend TLB size detection for AMD
Message-ID: <20120806153954.GB24903@aftab.osrc.amd.com>
References: <1344011869-21868-1-git-send-email-bp@amd64.org>
 <1344011869-21868-3-git-send-email-bp@amd64.org>
 <501C1953.8020807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501C1953.8020807@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 11:32:51AM -0700, H. Peter Anvin wrote:
> > -	if (boot_cpu_data.cpuid_level >= 2)
> > +	if (boot_cpu_data.cpuid_level >= 2 ||
> > +	    boot_cpu_data.extended_cpuid_level >= 0x80000006)
> >  		cpu_detect_tlb(&boot_cpu_data);
>
> This really belongs in cpu_detect_tlb() itself (or rather, in the
> subfunctions called by it.) Can we just lose the general test here,
> please?

Sure, will resend in a bit.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
