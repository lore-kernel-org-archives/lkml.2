Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2LXEZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 23:25:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8936 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2LXEZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 23:25:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 23 Dec 2012 20:23:11 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Mon, 24 Dec 2012 09:54:57 +0530
Subject: RE: [PATCH v3] usb: phy: use kzalloc to allocate struct
 tegra_usb_phy
Thread-Topic: [PATCH v3] usb: phy: use kzalloc to allocate struct
 tegra_usb_phy
Thread-Index: Ac3fvXVqGuZlj9JZQZ65o2k6AyfNNgB0RMqw
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1A40D473@BGMAIL02.nvidia.com>
References: <1356071656-10052-1-git-send-email-vbyravarasu@nvidia.com>
 <50D4CC9F.6080000@wwwdotorg.org>
In-Reply-To: <50D4CC9F.6080000@wwwdotorg.org>
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

Thanks Stephen.
Venu


> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Saturday, December 22, 2012 2:25 AM
> To: Venu Byravarasu
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; sshtylyov@mvista.com;
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH v3] usb: phy: use kzalloc to allocate struct tegra_usb_phy
> 
> On 12/20/2012 11:34 PM, Venu Byravarasu wrote:
> > Use kzalloc instead of kmalloc to allocate struct tegra_usb_phy.
> > This ensures that all function pointers in member u_phy are
> > initialized to NULL.
> 
> Seems fine to me. For the record, I'd like to take this through the
> Tegra tree with all the other Tegra-related USB patches in order to
> manage any dependencies, with the USB maintainers' Acks. Thanks.
