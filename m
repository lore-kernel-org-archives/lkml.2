Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2K3Jtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:49:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10436 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2K3Jts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:49:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 30 Nov 2012 01:49:02 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Kim, Milo" <Milo.Kim@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Sivaram Nair <sivaramn@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 30 Nov 2012 15:19:18 +0530
Subject: RE: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
 initialization
Thread-Topic: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
 initialization
Thread-Index: Ac3Oj6JhA/G6ohVnQ0uMm1NsrJ8QewAT+ADw
Message-ID: <D958900912E20642BCBC71664EFECE3E6E187A3DA1@BGMAIL02.nvidia.com>
References: <A874F61F95741C4A9BA573A70FE3998F6418F1B3@DQHE02.ent.ti.com>
	<D958900912E20642BCBC71664EFECE3E6E17CF0A07@BGMAIL02.nvidia.com>
	<A874F61F95741C4A9BA573A70FE3998F6418F30B@DQHE02.ent.ti.com>
 <20121129161358.9ae29f96.akpm@linux-foundation.org>
In-Reply-To: <20121129161358.9ae29f96.akpm@linux-foundation.org>
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
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Friday, November 30, 2012 5:44 AM
> To: Kim, Milo
> Cc: Venu Byravarasu; Samuel Ortiz; a.zummo@towertech.it;
> swarren@wwwdotorg.org; Sivaram Nair; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
> initialization
> 
> On Thu, 29 Nov 2012 23:11:37 +0000
> "Kim, Milo" <Milo.Kim@ti.com> wrote:
> 
> > Hi Venu
> >

> >
> 
> I've merged this patch into -mm for 3.8 along with a note-to-self that
> there might still be open issues.  Venu, please let us know if the
> above settles things?

Hi Andrew,

Above change is fine & I added my ACK to the change.
Due to recent change in the data sheet, which I'm not aware of, made
my previous comment.

Sorry for the confusion created.

Thanks,
Venu
