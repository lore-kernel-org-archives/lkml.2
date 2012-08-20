Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2HTPo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:44:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:14525 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2HTPoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:44:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,797,1336374000"; 
   d="scan'208";a="206547403"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH 00/11] x86/microcode: Early load microcode
Thread-Topic: [PATCH 00/11] x86/microcode: Early load microcode
Thread-Index: AQHNfRumQhrFoJay5EuUDCDRg9dQ6pdjTxeA//+LxAA=
Date: Mon, 20 Aug 2012 15:44:07 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122007787DDA@ORSMSX105.amr.corp.intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <20120820153927.GB8623@aftab.osrc.amd.com>
In-Reply-To: <20120820153927.GB8623@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Borislav Petkov [mailto:bp@amd64.org]
> Sent: Monday, August 20, 2012 8:39 AM
> To: Yu, Fenghua
> Cc: H Peter Anvin; Ingo Molnar; Thomas Gleixner; Mallick, Asit K;
> Tigran Aivazian; Andreas Herrmann; Borislav Petkov; linux-kernel; x86
> Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
> 
> On Sat, Aug 18, 2012 at 01:15:18AM -0700, Fenghua Yu wrote:
> >  Documentation/x86/earlyucode.txt        |   43 +++
> >  arch/x86/Kconfig                        |   22 ++
> >  arch/x86/include/asm/cpio.h             |   10 +
> >  arch/x86/include/asm/microcode.h        |   23 ++
> >  arch/x86/include/asm/microcode_intel.h  |  103 +++++++
> >  arch/x86/kernel/Makefile                |    3 +
> >  arch/x86/kernel/head64.c                |    6 +
> >  arch/x86/kernel/head_32.S               |    6 +
> >  arch/x86/kernel/microcode_core.c        |    7 +-
> >  arch/x86/kernel/microcode_core_early.c  |   74 +++++
> >  arch/x86/kernel/microcode_intel.c       |  185 +------------
> >  arch/x86/kernel/microcode_intel_early.c |  482
> +++++++++++++++++++++++++++++++
> >  arch/x86/kernel/microcode_intel_lib.c   |  163 +++++++++++
> 
> One more thing:
> 
> This screams for adding a directory called "microcode" in the kernel
> sources and moving all the microcode-related files there. IOW:
> 
> arch/x86/kernel/cpu/microcode/core.c
> arch/x86/kernel/cpu/microcode/core_early.c
> arch/x86/kernel/cpu/microcode/intel.c
> arch/x86/kernel/cpu/microcode/amd.c
> ...
> 
> And yes, they should be under "cpu" too.

That's right.

Thanks.

-Fenghua
