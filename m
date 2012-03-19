Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab2CSInf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:43:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5429 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab2CSInd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:43:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 19 Mar 2012 01:43:26 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Date: Mon, 19 Mar 2012 14:13:20 +0530
Subject: RE: [PATCH] mfd: Fix compilation error in TPS65910.h
Thread-Topic: [PATCH] mfd: Fix compilation error in TPS65910.h
Thread-Index: Ac0Drop7QcOR8Za9QT6KBJHsgMVrrQB/aX8Q
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3127A5D@BGMAIL02.nvidia.com>
References: <1331882917-27960-1-git-send-email-vbyravarasu@nvidia.com>
 <20120316200154.GU20524@sortiz-mobl>
In-Reply-To: <20120316200154.GU20524@sortiz-mobl>
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

Thanks Mark and Samuel.

> -----Original Message-----
> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> Sent: Saturday, March 17, 2012 1:32 AM
> To: Venu Byravarasu
> Cc: linux-kernel@vger.kernel.org; jedu@slimlogic.co.uk; lrg@slimlogic.co.uk;
> broonie@opensource.wolfsonmicro.com; gg@slimlogic.co.uk
> Subject: Re: [PATCH] mfd: Fix compilation error in TPS65910.h
> 
> Hi Venu,
> 
> On Fri, Mar 16, 2012 at 12:58:37PM +0530, Venu Byravarasu wrote:
> > From: Venu Byravarasu <vbyravarasu@nvidia.com>
> >
> > Fix compilation error due to including TPS65910.h
> Probably too late for 3.3, but I applied this patch anyway.
> 
> Cheers,
> Samuel.
> 
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
