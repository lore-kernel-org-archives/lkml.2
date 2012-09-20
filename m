Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2ITMCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:02:45 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9551 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2ITMCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:02:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 20 Sep 2012 05:02:42 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "balbi@ti.com" <balbi@ti.com>, Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Date: Thu, 20 Sep 2012 17:32:36 +0530
Subject: RE: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Topic: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Index: Ac2XJ4dvejdRUxl4RAeK0kRArf0yEQAADkVA
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF601261@BGMAIL02.nvidia.com>
References: <1347519738-24162-1-git-send-email-vbyravarasu@nvidia.com>
 <5052157F.8040201@wwwdotorg.org>
 <D958900912E20642BCBC71664EFECE3E6DDF601145@BGMAIL02.nvidia.com>
 <20120920120004.GD3523@kroah.com>
In-Reply-To: <20120920120004.GD3523@kroah.com>
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

Thanks Greg, for quick response.
Venu


> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, September 20, 2012 5:30 PM
> To: Venu Byravarasu
> Cc: balbi@ti.com; Stephen Warren; linux-kernel@vger.kernel.org; linux-
> usb@vger.kernel.org; linux-tegra@vger.kernel.org; Stephen Warren;
> stern@rowland.harvard.edu
> Subject: Re: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
> 
> On Thu, Sep 20, 2012 at 10:50:51AM +0530, Venu Byravarasu wrote:
> > Hi Greg & Felipe,
> >
> > Can any of you please review and merge this change?
> 
> That's up to Felipe.

