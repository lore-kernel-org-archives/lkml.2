Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab2JVIaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:30:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14427 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2JVIaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:30:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 22 Oct 2012 01:18:08 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Oct 2012 14:00:00 +0530
Subject: RE: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Topic: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Index: Ac2uEDkPvBKf9ZDLTkmiZcxekhLfVACHnvtA
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDFB0CDCA@BGMAIL02.nvidia.com>
References: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
 <20121019153555.GC440@arwen.pp.htv.fi>
In-Reply-To: <20121019153555.GC440@arwen.pp.htv.fi>
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
> Sent: Friday, October 19, 2012 9:06 PM
> To: Venu Byravarasu
> Cc: stern@rowland.harvard.edu; gregkh@linuxfoundation.org;
> balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
> 
> * PGP Signed by an unknown key
> 
> Hi,
> 
> On Fri, Oct 19, 2012 at 04:08:05PM +0530, Venu Byravarasu wrote:
> > NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> 
> I was reading this "driver" more closely and I have a bunch of questions
> about it, but the most important of all of them is: "why isn't that a
> real PHY driver ?". It doesn't have a probe() function, it doesn't use
> struct usb_phy to represent the PHY, it has a bunch of tegra-specific
> APIs and we can't let those continue.
> 
> Please, take a look at drivers/usb/phy/omap_usb2.c (misnamed actually,
> should be phy-omap-usb2.c so we have a common prefix) to see how your
> PHY driver should look like and which sort of functionality if should
> expose to the rest of the kernel.

Hi Felipe, 

I'll go through omap phy driver and prepare similar patches for tegra phy driver
and push them with upcoming patches.
As current patch is mostly re-organizing the existing phy driver, can you plz merge
This as is?

Thanks,
Venu

> 
> Please comment on the above.
> 
> cheers
> 
> --
> balbi
> 
> * Unknown Key
> * 0x35CAA444
