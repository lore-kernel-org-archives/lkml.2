Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab2HSQjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 12:39:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:19475 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab2HSQjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 12:39:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,794,1336374000"; 
   d="scan'208";a="205567137"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
Thread-Topic: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces
 for early load ucode
Thread-Index: AQHNfRunwqP95+1vaUy4HYughHZSRZdgoT4A//+XQYCAANiLAIAARpuA
Date: Sun, 19 Aug 2012 16:39:42 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122007787B22@ORSMSX105.amr.corp.intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
 <20120818224442.GB32120@khazad-dum.debian.net>
 <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
 <503078A2.9030204@zytor.com>
In-Reply-To: <503078A2.9030204@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Saturday, August 18, 2012 10:25 PM
> To: Yu, Fenghua
> Cc: Henrique de Moraes Holschuh; Ingo Molnar; Thomas Gleixner; Mallick,
> Asit K; Tigran Aivazian; Andreas Herrmann; Borislav Petkov; linux-
> kernel; x86
> Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define
> interfaces for early load ucode
> 
> On 08/18/2012 07:38 PM, Yu, Fenghua wrote:
> >
> > In this early phase, detecting vendor in initrd is much simpler code.
> > Otherwise, detecting vendor by cpuid (and without cpuid) needs
> > similar but different code as existing functions and coding would be
> > awkward.
> >
> 
> I'm confused by this statement.  Getting the vendor from CPUID is a few
> lines of code, and non-CPUID processors don't support microcode loading.
> 
Will checking vendor info from CPUID in next version.

> > Why name it ".hex" when you're loading binary data?  I suggest ".bin".
> It
> > is confusing to have .hex there, since you're not dealing with the
> Intel HEX
> > format, nor anything text-like.
> 
> Actually I think we can also skip one level of indirection here... no
> need to mention "microcode" twice.
> 
> kernel/x86/microcode/GenuineIntel or GenuineIntel.bin seems good
> enough... the idea here of course is that the string can come from
> CPUID.
That's right. Will do this.

Thanks.

-Fenghua
