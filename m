Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1HQVjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:39:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:26025 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1HQVjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:39:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,241,1312182000"; 
   d="scan'208";a="42445915"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Andy Lutomirski <luto@MIT.EDU>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 17 Aug 2011 14:38:30 -0700
Subject: RE: [PATCH v4 1/2] x86: Enable fast strings on Intel if BIOS hasn't
 already
Thread-Topic: [PATCH v4 1/2] x86: Enable fast strings on Intel if BIOS
 hasn't already
Thread-Index: Acxc5nXlDaOI/3DsS5uzJsWj/LlLOgAP04Qw
Message-ID: <493994B35A117E4F832F97C4719C4C040132E3F8D2@orsmsx505.amr.corp.intel.com>
References: <cover.1313586473.git.luto@mit.edu>
 <e6c5440954c28e9738b8d4919a9db2d10c9a1757.1313586473.git.luto@mit.edu>
In-Reply-To: <e6c5440954c28e9738b8d4919a9db2d10c9a1757.1313586473.git.luto@mit.edu>
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
> Sent: Wednesday, August 17, 2011 7:03 AM
> To: x86@kernel.org; linux-kernel@vger.kernel.org
> Cc: Yu, Fenghua; Matthew Garrett; Len Brown; linux-
> acpi@vger.kernel.org; Ingo Molnar; Andy Lutomirski
> Subject: [PATCH v4 1/2] x86: Enable fast strings on Intel if BIOS
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

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

