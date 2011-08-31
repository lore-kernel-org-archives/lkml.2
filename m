Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1HaTp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:45:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9071 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab1HaTp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:45:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 31 Aug 2011 12:45:10 -0700
From: Andrew Chew <AChew@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Russell King <linux@arm.linux.org.uk>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Date: Wed, 31 Aug 2011 12:45:09 -0700
Subject: RE: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't use
 irq_to_gpio()
Thread-Topic: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't use
 irq_to_gpio()
Thread-Index: AcxoFfStaq2eTeWwQUWLOq4nCpySlAAAF0Sw
Message-ID: <643E69AA4436674C8F39DCC2C05F76383CF3C784A3@HQMAIL03.nvidia.com>
References: <1314819657-828-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1314819657-828-1-git-send-email-swarren@nvidia.com>
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

> Subject: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't 
> use irq_to_gpio()
> 
> Tegra doesn't have irq_to_gpio() any more, and ak8975 is included in
> tegra_defconfig. This causes a build failure. Solve this with 
> a heavy-handed
> method for now.
> 
> I suspect the long-term solution is to pass both the IRQ and GPIO IDs
> to the driver; the GPIO ID coming from either platform data, 
> or perhaps
> enhancing struct i2c_client to add a gpio field alongside irq.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---

The three patches in this set LGTM.

Acked-by: Andrew Chew <achew@nvidia.com> 
