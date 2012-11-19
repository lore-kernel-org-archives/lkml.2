Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2KSIBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:01:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:18510 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab2KSIBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:01:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,277,1352102400"; 
   d="scan'208";a="170029201"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mmc,sdio: Fix the panic due to devname NULL when
 calling pm_runtime_set_active()
Thread-Topic: [PATCH] mmc,sdio: Fix the panic due to devname NULL when
 calling pm_runtime_set_active()
Thread-Index: AQHNxioZ0gQBq8qVP0+UDnv8vnCPTZfwyykg
Date: Mon, 19 Nov 2012 08:01:27 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1D445F@SHSMSX101.ccr.corp.intel.com>
References: <1353070447.15558.1681.camel@cliu38-desktop-build>
 <CAK=WgbYiKFpSeyKZU3OWvbq4VDKRMFQvxwPbyxsBbEYJGQU1sA@mail.gmail.com>
 <27240C0AC20F114CBF8149A2696CBE4A1D4191@SHSMSX101.ccr.corp.intel.com>
 <CAK=WgbYFbewu4bw5fhgjiG83oWiAcmBtRQF3_Jeba0CYKg75Qg@mail.gmail.com>
In-Reply-To: <CAK=WgbYFbewu4bw5fhgjiG83oWiAcmBtRQF3_Jeba0CYKg75Qg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ohad Ben-Cohen [mailto:ohad@wizery.com]
> Sent: Monday, November 19, 2012 3:47 PM
> To: Liu, Chuansheng
> Cc: Chris Ball; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] mmc,sdio: Fix the panic due to devname NULL when
> calling pm_runtime_set_active()
> 
> On Mon, Nov 19, 2012 at 7:57 AM, Liu, Chuansheng
> <chuansheng.liu@intel.com> wrote:
> > Rechecked these codes, the trace event runtime_pm_status is added newly,
> this is different with vanilla
> > Linux.
> 
> Not sure I'm following - can you point out which tree are you working with ?
Sorry, it is added internally for debugging purpose.
> 
> > So I still think that calling pm_runtime_set_active is not safe when dev_name
> is NULL.
> > If you agree this point, I can refine the code that moving "init the dev_name "
> from mmc_add_card
> > to mmc_sdio_init_card.
> 
> This sounds more reasonable.
I will try a V2 patch soon, thanks.

> 
> Thanks,
> Ohad.
