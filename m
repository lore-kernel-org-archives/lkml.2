Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab2HUU6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:58:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:3062 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab2HUU6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:58:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,804,1336374000"; 
   d="scan'208";a="211879475"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
Thread-Topic: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces
 for early load ucode
Thread-Index: AQHNfRunwqP95+1vaUy4HYughHZSRZdgoT4A//+XQYCAANiLAIAARpuAgAHdegCAAGU7gIAAAxCAgAEVvBCAAHrTAIAACe0A//+K0CCAAHZ9gP//i9gw
Date: Tue, 21 Aug 2012 20:58:09 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220077884B0@ORSMSX105.amr.corp.intel.com>
References: <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
 <20120818224442.GB32120@khazad-dum.debian.net>
 <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
 <503078A2.9030204@zytor.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007787B22@ORSMSX105.amr.corp.intel.com>
 <20120820140630.GD24149@aftab.osrc.amd.com> <50329951.9030805@zytor.com>
 <20120820201947.GC15006@aftab.osrc.amd.com>
 <3E5A0FA7E9CA944F9D5414FEC6C712200778846C@ORSMSX105.amr.corp.intel.com>
 <5033EBE6.5080608@zytor.com> <20120821204858.GA30472@aftab.osrc.amd.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007788491@ORSMSX105.amr.corp.intel.com>
 <5033F551.8040402@zytor.com>
In-Reply-To: <5033F551.8040402@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Tuesday, August 21, 2012 1:54 PM
> To: Yu, Fenghua
> Cc: Borislav Petkov; Henrique de Moraes Holschuh; Ingo Molnar; Thomas
> Gleixner; Mallick, Asit K; Tigran Aivazian; Andreas Herrmann; Borislav
> Petkov; linux-kernel; x86
> Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define
> interfaces for early load ucode
> 
> On 08/21/2012 01:52 PM, Yu, Fenghua wrote:
> >> -----Original Message-----
> >> From: Borislav Petkov [mailto:bp@amd64.org]
> >> Sent: Tuesday, August 21, 2012 1:49 PM
> >> To: H. Peter Anvin
> >> Cc: Yu, Fenghua; Henrique de Moraes Holschuh; Ingo Molnar; Thomas
> >> Gleixner; Mallick, Asit K; Tigran Aivazian; Andreas Herrmann;
> Borislav
> >> Petkov; linux-kernel; x86
> >> Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define
> >> interfaces for early load ucode
> >>
> >> On Tue, Aug 21, 2012 at 01:13:26PM -0700, H. Peter Anvin wrote:
> >>> I don't know what Borislav was suggesting with "BIOS overrides", is
> >>> that another CPU-specific thing?
> >>
> >> Not CPU- but rather platform-specific. It is Thomas Renninger's
> >> mechanism to override BIOS tables.
> >
> > That's ACPI override. I think the ACPI tables could be put in
> kernel/x86/acpi/.
> >
> 
> kernel/acpi... ACPI is not x86-specific.

That's right.

Thanks.

-Fenghua
