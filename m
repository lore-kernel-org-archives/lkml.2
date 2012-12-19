Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab2LSFiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:38:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19709 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2LSFim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:38:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 18 Dec 2012 21:36:20 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Wed, 19 Dec 2012 11:08:34 +0530
Subject: RE: [PATCH] usb: phy: tegra: Using devm API for memory allocation
Thread-Topic: [PATCH] usb: phy: tegra: Using devm API for memory allocation
Thread-Index: Ac3dPWWQMnRDaS8ASzGOAV4V619fDQAbWp3Q
Message-ID: <D958900912E20642BCBC71664EFECE3E6E19E0BFC4@BGMAIL02.nvidia.com>
References: <1355811683-29981-1-git-send-email-vbyravarasu@nvidia.com>
 <50D09AC7.9050503@wwwdotorg.org>
In-Reply-To: <50D09AC7.9050503@wwwdotorg.org>
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
> Sent: Tuesday, December 18, 2012 10:03 PM
> To: Venu Byravarasu
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH] usb: phy: tegra: Using devm API for memory allocation
> 
> On 12/17/2012 11:21 PM, Venu Byravarasu wrote:
> > Using devm_kzalloc for allocating memory needed for PHY
> > pointer and hence removing kfree calls to PHY pointer.
> 
> Since the kfree() here used to be in tegra_usb_phy_close() rather than
> any remove() function, does it actually make sense to use
> devm_kzalloc(); would plain using kzalloc() instead, and not removing
> the kfree() calls, be better?
> 
 
Stephen,
As you mentioned I can replace kmalloc with kzalloc in the original code 
and push an updated patch.
However, I just wanted to understand if there exists any issue
in using devm_kzalloc instead of kzalloc?

> When the PHY code gets converted to be an actual probed driver, then
> perhaps using devm will make sense.
