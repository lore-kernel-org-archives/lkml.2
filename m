Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2CZLDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:03:12 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14009 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2CZLDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:03:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 26 Mar 2012 04:03:11 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Mar 2012 16:30:57 +0530
Subject: RE: [PATCH 2/2] mfd: tps65090: Don't use I2C-specific suspend and
 resume operations
Thread-Topic: [PATCH 2/2] mfd: tps65090: Don't use I2C-specific suspend and
 resume operations
Thread-Index: Ac0LP3wJJp1CdslUQeerqItkLmn8uwAACw7A
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3128292@BGMAIL02.nvidia.com>
References: <1332441541-28197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1332441541-28197-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <D958900912E20642BCBC71664EFECE3E6DD312816D@BGMAIL02.nvidia.com>
 <20120326105908.GJ3098@opensource.wolfsonmicro.com>
In-Reply-To: <20120326105908.GJ3098@opensource.wolfsonmicro.com>
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

> > > It's not clear to me that we should have these operations at all...
> 
> > Can you please explain why do you think that these operations are not
> needed?
> 
> They've been deprecated for over a year, if you'd looked at the kernel
> boot log you'd see that it's been complaining about them at startup
> time.
Thanks, understood.
