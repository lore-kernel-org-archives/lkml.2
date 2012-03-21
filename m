Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2CUF1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:27:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5574 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2CUF1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:27:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 20 Mar 2012 22:27:22 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Igor Grinberg <grinberg@compulab.co.il>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Date: Wed, 21 Mar 2012 10:57:18 +0530
Subject: RE: [PATCH] mfd: Fix compilation error in TPS65910.h
Thread-Topic: [PATCH] mfd: Fix compilation error in TPS65910.h
Thread-Index: Ac0GhyMZIKmtk70TSw+8XxBrEM08kwAnBbzg
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3127DD4@BGMAIL02.nvidia.com>
References: <1331882917-27960-1-git-send-email-vbyravarasu@nvidia.com>
 <20120316200154.GU20524@sortiz-mobl>
 <D958900912E20642BCBC71664EFECE3E6DD3127A5D@BGMAIL02.nvidia.com>
 <4F6860AF.5060404@compulab.co.il>
In-Reply-To: <4F6860AF.5060404@compulab.co.il>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes Igor, this change should get into stable as well.

> -----Original Message-----
> From: Igor Grinberg [mailto:grinberg@compulab.co.il]
> Sent: Tuesday, March 20, 2012 4:19 PM
> To: Venu Byravarasu
> Cc: Samuel Ortiz; linux-kernel@vger.kernel.org; jedu@slimlogic.co.uk;
> lrg@slimlogic.co.uk; broonie@opensource.wolfsonmicro.com;
> gg@slimlogic.co.uk
> Subject: Re: [PATCH] mfd: Fix compilation error in TPS65910.h
> 
> On 03/19/12 10:43, Venu Byravarasu wrote:
> > Thanks Mark and Samuel.
> >
> >> -----Original Message-----
> >> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> >> Sent: Saturday, March 17, 2012 1:32 AM
> >> To: Venu Byravarasu
> >> Cc: linux-kernel@vger.kernel.org; jedu@slimlogic.co.uk; lrg@slimlogic.co.uk;
> >> broonie@opensource.wolfsonmicro.com; gg@slimlogic.co.uk
> >> Subject: Re: [PATCH] mfd: Fix compilation error in TPS65910.h
> >>
> >> Hi Venu,
> >>
> >> On Fri, Mar 16, 2012 at 12:58:37PM +0530, Venu Byravarasu wrote:
> >>> From: Venu Byravarasu <vbyravarasu@nvidia.com>
> >>>
> >>> Fix compilation error due to including TPS65910.h
> >> Probably too late for 3.3, but I applied this patch anyway.
> 
> Venu,
> Should this go also to stable?
> 
> If it should then, Samuel, can you please add Cc: stable@vger.kernel.org?
> 
> 
> --
> Regards,
> Igor.
