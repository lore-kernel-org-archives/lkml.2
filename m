Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2ISHtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:49:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17842 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab2ISHts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:49:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 19 Sep 2012 00:48:34 -0700
Subject: Re: [PATCH v2 1/1] USB: EHCI: Tegra: Fix wrong register definition
From: Jim Lin <jilin@nvidia.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20120919062927.GB15492@kroah.com>
References: <1348026530-17327-1-git-send-email-jilin@nvidia.com>
	 <20120919062927.GB15492@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Sep 2012 15:53:42 +0800
Message-ID: <1348041222.20200.20.camel@jilin-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 14:29 +0800, Greg KH wrote:
> On Wed, Sep 19, 2012 at 11:48:50AM +0800, Jim Lin wrote:
> > Fix the issue that EHCI registers, hostpc[0] and usbmode_ex,
> > are not correctly accessed on Tegra3 platform.
> > 
> > Signed-off-by: Jim Lin <jilin@nvidia.com>
> > ---
> > Changes in v2:
> > - Modify array size for reserved4[] only.
> > - Note that defining hostpc[0] is for a variable-length object.
> 
> Didn't I already apply V1 of this patch?  Can you now send me a fixup
> given that the first patch had a problem?
> 
> thanks,
> 
> greg k-h
If you have applied v1, that's fine.
V2 is just another simplified change, no hurt.
You can ignore it.

Thanks.


