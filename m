Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2JVKd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:33:56 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3806 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2JVKdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:33:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 22 Oct 2012 03:33:53 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Oct 2012 16:03:49 +0530
Subject: RE: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Topic: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Index: Ac2wPxZ4FvbfnTW7T9Kz8G0eH59L2wAAAtBQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDFB0CE26@BGMAIL02.nvidia.com>
References: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
 <20121019153555.GC440@arwen.pp.htv.fi>
 <D958900912E20642BCBC71664EFECE3E6DDFB0CDCA@BGMAIL02.nvidia.com>
 <20121022100240.GK14033@arwen.pp.htv.fi>
 <D958900912E20642BCBC71664EFECE3E6DDFB0CE1E@BGMAIL02.nvidia.com>
 <20121022101623.GM14033@arwen.pp.htv.fi>
In-Reply-To: <20121022101623.GM14033@arwen.pp.htv.fi>
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
> Sent: Monday, October 22, 2012 3:46 PM
> To: Venu Byravarasu
> Cc: balbi@ti.com; stern@rowland.harvard.edu;
> gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
> 
> * PGP Signed by an unknown key
> 
> Hi,
> 
> >
> > Hi Felipe,
> >
> > The current patch splits out the existing tegra USB phy driver into two parts,
> as
> > you would have already noticed from the code.
> > The probe and etc changes that you asked to add, will be applicable to
> common
> > Phy driver and should not have any implications on SOC dependent phy
> driver.
> 
> what is this SOC dependent PHY driver ? 

SOC dependent PHY driver actually deals with the PHY interface programming.
e.g. please see code present in tegra2_usb_driver.c. 

> What sort of dependencies are
> there ? Those differences should be handled with runtime checks.
 
As PHY related bugs got fixed across different set of SOCs apart from
adding few features, wanted to separate this out from common PHY
functionality. This will help us in adding support for different SOCs with
minimum set of changes.

> --
> balbi
> 
> * Unknown Key
> * 0x35CAA444
