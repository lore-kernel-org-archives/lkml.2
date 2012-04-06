Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2DFFqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 01:46:09 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16704 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2DFFqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 01:46:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 05 Apr 2012 22:46:06 -0700
Message-ID: <4F7E80CB.5060706@nvidia.com>
Date: Fri, 6 Apr 2012 11:06:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH V1] regulator: Add support for RICOH PMIC RC5T583 regulator
References: <1333523640-8820-1-git-send-email-ldewangan@nvidia.com> <20120404104948.GA9693@opensource.wolfsonmicro.com> <CAP=VYLq_X7NJb=j_GNTHwrCyW1pbZJ4duknKCXEyeAezSkH4gA@mail.gmail.com>
In-Reply-To: <CAP=VYLq_X7NJb=j_GNTHwrCyW1pbZJ4duknKCXEyeAezSkH4gA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2012 10:07 AM, Paul Gortmaker wrote:
>
> It appears this breaks linux-next allmodconfig build, because it
> uses an uppercase V in the v2 of its MODULE_LICENSE.
>
> FATAL: modpost: GPL-incompatible module rc5t583-regulator.ko uses
> GPL-only symbol 'platform_driver_unregister'
> make[2]: *** [__modpost] Error 1
> .


Oops, my bad, I did not realize it. I send the patch for fixing this 
license issue.
Is it possible to catch such issue through check-patch?

