Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1HIPlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:41:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:18930 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab1HIPk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:40:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,344,1309762800"; 
   d="scan'208";a="37339424"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Andy Lutomirski <luto@MIT.EDU>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "Anvin, H Peter" <h.peter.anvin@intel.com>
Date: Tue, 9 Aug 2011 08:40:06 -0700
Subject: RE: [PATCH v3 1/2] x86: Enable fast strings on Intel if BIOS hasn't
 already
Thread-Topic: [PATCH v3 1/2] x86: Enable fast strings on Intel if BIOS
 hasn't already
Thread-Index: AcxWkaMquDEgaC6aRVyD4/LS5ifVIgAGMjbw
Message-ID: <493994B35A117E4F832F97C4719C4C040132CE80CE@orsmsx505.amr.corp.intel.com>
References: <cover.1312893572.git.luto@mit.edu>
 <d9f3056c77b6cd44a2f4c90278ce483a011dda12.1312893572.git.luto@mit.edu>
In-Reply-To: <d9f3056c77b6cd44a2f4c90278ce483a011dda12.1312893572.git.luto@mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@MIT.EDU]
> Sent: Tuesday, August 09, 2011 5:41 AM
> To: x86@kernel.org; linux-kernel@vger.kernel.org
> Cc: Yu, Fenghua; Matthew Garrett; Len Brown; linux-
> acpi@vger.kernel.org; Ingo Molnar; Andy Lutomirski
> Subject: [PATCH v3 1/2] x86: Enable fast strings on Intel if BIOS
> hasn't already
> 
> Intel SDM volume 3A, 8.4.2 says:
> 
>   Software can disable fast-string operation by clearing the
>   fast-string-enable bit (bit 0) of IA32_MISC_ENABLE MSR.
>   However, Intel recomments that system software always enable
>   fast-string operation.
> 
> The Intel DQ67SW board (with latest BIOS) disables fast string
> operations if TXT is enabled.  A Lenovo X220 disables it regardless
> of TXT setting.  I doubt I'm the only person with a dumb BIOS like
> this.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/kernel/cpu/intel.c |   28 +++++++++++++++++++++++-----
>  1 files changed, 23 insertions(+), 5 deletions(-)

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

