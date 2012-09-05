Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab2IEMyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:54:21 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11250 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2IEMyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:54:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 05 Sep 2012 05:53:52 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, "balbi@ti.com" <balbi@ti.com>
CC: "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Wed, 5 Sep 2012 18:24:13 +0530
Subject: RE: [PATCH v2] usb: move phy driver from mach-tegra to drivers/usb
Thread-Topic: [PATCH v2] usb: move phy driver from mach-tegra to drivers/usb
Thread-Index: Ac2K5w02QOhWsR8SRTShCo9XMzeuOwAfnWWQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDE77533D@BGMAIL02.nvidia.com>
References: <1346395526-18219-1-git-send-email-vbyravarasu@nvidia.com>
 <5046772F.6060908@wwwdotorg.org>
In-Reply-To: <5046772F.6060908@wwwdotorg.org>
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
> Sent: Wednesday, September 05, 2012 3:19 AM
> To: balbi@ti.com
> Cc: Venu Byravarasu; ccross@android.com; olof@lixom.net;
> linux@arm.linux.org.uk; stern@rowland.harvard.edu;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; linux-
> tegra@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> usb@vger.kernel.org
> Subject: Re: [PATCH v2] usb: move phy driver from mach-tegra to drivers/usb
> 
> On 08/31/2012 12:45 AM, Venu Byravarasu wrote:
> > As part of this patch:
> > 	1. Moved existing tegra phy driver to drivers/USB directory.
> > 	2. Added standard USB phy driver APIs to tegra phy driver.
> >
> > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> 
> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> Felipe, Would it be possible to apply this patch to a topic branch, so
> that I can merge it into the Tegra tree? The reason is that I'd like to
> remove Tegra's devices.[ch] in kernel 3.7, but to do that, I need to
> move a tiny chunk of code out of that file somewhere else, and doing
> that relies on adding a #include to usb_phy.h/tegra_usb_phy.h, which is
> renamed in this patch.
> 
> Alternatively, if you don't think it'll cause any merge conflicts with
> the USB PHY tree, I can just take this patch through the Tegra tree if
> you want. Venu, do you plan any other patches within the next couple
> weeks or so (i.e. before 3.6-rc6) that will depend on this patch? If so,
> taking it only through the Tegra tree might not work so well.

Thanks Stephen for verifying the changes.
I'm planning to push next patches, with tegra3 phy support added, very soon.  

> Thanks.
