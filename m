Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2IYG7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:59:04 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1105 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2IYG7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:59:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 24 Sep 2012 23:49:44 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Date: Tue, 25 Sep 2012 12:28:55 +0530
Subject: RE: [PATCH v2] rtc: tps65910: Use platform_get_irq to get RTC irq
 details
Thread-Topic: [PATCH v2] rtc: tps65910: Use platform_get_irq to get RTC irq
 details
Thread-Index: Ac2a5fNWIJTqRzi3SfKZIK82M0FfeQABTdsQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF601792@BGMAIL02.nvidia.com>
References: <1348550964-32534-1-git-send-email-vbyravarasu@nvidia.com>
 <50614D4C.6080509@wwwdotorg.org>
In-Reply-To: <50614D4C.6080509@wwwdotorg.org>
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

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Tuesday, September 25, 2012 11:51 AM
> To: Venu Byravarasu
> Cc: akpm@linux-foundation.org; a.zummo@towertech.it; linux-
> kernel@vger.kernel.org; rtc-linux@googlegroups.com
> Subject: Re: [PATCH v2] rtc: tps65910: Use platform_get_irq to get RTC irq
> details
> 
> On 09/24/2012 11:29 PM, Venu Byravarasu wrote:
> > As RTC driver needs only irq number from platform data,
> > using platform_get_irq(), instead of generic dev_get_platdata().
> 
> This seems fine to me now.
> 
> However, it'd be useful to post all the patches related to this issue at
> one time, so we can get a clear picture of everything that goes into
> fixing the problem.

Sure Stephen.
Will push mfd patches soon.
 

