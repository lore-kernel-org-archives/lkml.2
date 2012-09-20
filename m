Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab2ITFU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 01:20:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19061 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2ITFU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 01:20:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 19 Sep 2012 22:20:56 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Date: Thu, 20 Sep 2012 10:50:51 +0530
Subject: RE: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Topic: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Index: Ac2R09/KOd1lh770SAO+BuABnHErhgFG6EhA
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF601145@BGMAIL02.nvidia.com>
References: <1347519738-24162-1-git-send-email-vbyravarasu@nvidia.com>
 <5052157F.8040201@wwwdotorg.org>
In-Reply-To: <5052157F.8040201@wwwdotorg.org>
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

Hi Greg & Felipe,

Can any of you please review and merge this change?

Thanks,
Venu


> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Thursday, September 13, 2012 10:49 PM
> To: Venu Byravarasu
> Cc: stern@rowland.harvard.edu; gregkh@linuxfoundation.org;
> balbi@ti.com; Stephen Warren; linux-kernel@vger.kernel.org; linux-
> usb@vger.kernel.org; linux-tegra@vger.kernel.org
> Subject: Re: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
> 
> On 09/13/2012 01:02 AM, Venu Byravarasu wrote:
> > NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> > In order to support USB PHY drivers on these SoCs, existing
> > PHY driver is split into SoC agnostic common USB PHY driver
> > and Tegra20-specific USB phy driver. This will facilitate
> > easy addition and deletion of phy drivers for Tegra SoCs.
> >
> > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> 
> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
