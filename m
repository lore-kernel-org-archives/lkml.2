Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab2ISIF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:05:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44738 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab2ISIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:05:46 -0400
Date: Wed, 19 Sep 2012 09:04:12 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jim Lin <jilin@nvidia.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] USB: EHCI: Tegra: Fix wrong register definition
Message-ID: <20120919080412.GA18986@kroah.com>
References: <1348026530-17327-1-git-send-email-jilin@nvidia.com>
 <20120919062927.GB15492@kroah.com>
 <1348041222.20200.20.camel@jilin-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348041222.20200.20.camel@jilin-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 03:53:42PM +0800, Jim Lin wrote:
> On Wed, 2012-09-19 at 14:29 +0800, Greg KH wrote:
> > On Wed, Sep 19, 2012 at 11:48:50AM +0800, Jim Lin wrote:
> > > Fix the issue that EHCI registers, hostpc[0] and usbmode_ex,
> > > are not correctly accessed on Tegra3 platform.
> > > 
> > > Signed-off-by: Jim Lin <jilin@nvidia.com>
> > > ---
> > > Changes in v2:
> > > - Modify array size for reserved4[] only.
> > > - Note that defining hostpc[0] is for a variable-length object.
> > 
> > Didn't I already apply V1 of this patch?  Can you now send me a fixup
> > given that the first patch had a problem?
> > 
> > thanks,
> > 
> > greg k-h
> If you have applied v1, that's fine.

You should have gotten an email from me saying I applied it, did that
not go through properly?

thanks,

greg k-h
