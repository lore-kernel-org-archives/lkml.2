Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2IUJu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:50:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1786 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2IUJux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:50:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 21 Sep 2012 02:42:02 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Date: Fri, 21 Sep 2012 15:20:46 +0530
Subject: RE: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Topic: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Index: Ac2X3Vv6rwikqqqNSfWXaljrssdDwgAAMdFA
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF6013ED@BGMAIL02.nvidia.com>
References: <1347519738-24162-1-git-send-email-vbyravarasu@nvidia.com>
 <5052157F.8040201@wwwdotorg.org>
 <D958900912E20642BCBC71664EFECE3E6DDF601145@BGMAIL02.nvidia.com>
 <20120920120004.GD3523@kroah.com>
 <D958900912E20642BCBC71664EFECE3E6DDF601261@BGMAIL02.nvidia.com>
 <20120921093710.GC15626@arwen.pp.htv.fi>
In-Reply-To: <20120921093710.GC15626@arwen.pp.htv.fi>
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
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Friday, September 21, 2012 3:07 PM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; balbi@ti.com; Stephen Warren; linux-
> kernel@vger.kernel.org; linux-usb@vger.kernel.org; linux-
> tegra@vger.kernel.org; Stephen Warren; stern@rowland.harvard.edu
> Subject: Re: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
> 
> * PGP Signed by an unknown key
> 
> Hi,
> 
> On Thu, Sep 20, 2012 at 05:32:36PM +0530, Venu Byravarasu wrote:
> > Thanks Greg, for quick response.
> 
> I'm waiting for a newer version fixing Kishon's comments. 

As I mentioned in reply to his comments,  most of the patch is
dealing with re-organizing the code. Hence kept the cleaning
part aside for next patch.

> BTW, his comment about pdata usage is 100% valid. You should fix that.
> 

Are you referring to below comments:

It's better you have the below code under *if (np)*, since both device
node and pdata co-exist for you.
> +       phy_type = of_property_match_string(np, "phy_type", "utmi");
> +       if (phy_type >= 0)
 
If so, I can address it and push an updated patch with that.

> --
> balbi
> 
> * Unknown Key
> * 0x35CAA444
