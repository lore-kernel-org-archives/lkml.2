Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab2KSHrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:47:16 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51815 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2KSHrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:47:15 -0500
MIME-Version: 1.0
X-Originating-IP: [85.250.20.247]
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A1D4191@SHSMSX101.ccr.corp.intel.com>
References: <1353070447.15558.1681.camel@cliu38-desktop-build>
 <CAK=WgbYiKFpSeyKZU3OWvbq4VDKRMFQvxwPbyxsBbEYJGQU1sA@mail.gmail.com> <27240C0AC20F114CBF8149A2696CBE4A1D4191@SHSMSX101.ccr.corp.intel.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 19 Nov 2012 09:46:54 +0200
Message-ID: <CAK=WgbYFbewu4bw5fhgjiG83oWiAcmBtRQF3_Jeba0CYKg75Qg@mail.gmail.com>
Subject: Re: [PATCH] mmc,sdio: Fix the panic due to devname NULL when calling pm_runtime_set_active()
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 7:57 AM, Liu, Chuansheng
<chuansheng.liu@intel.com> wrote:
> Rechecked these codes, the trace event runtime_pm_status is added newly, this is different with vanilla
> Linux.

Not sure I'm following - can you point out which tree are you working with ?

> So I still think that calling pm_runtime_set_active is not safe when dev_name is NULL.
> If you agree this point, I can refine the code that moving "init the dev_name " from mmc_add_card
> to mmc_sdio_init_card.

This sounds more reasonable.

Thanks,
Ohad.
