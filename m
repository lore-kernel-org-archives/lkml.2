Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2ISG3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 02:29:34 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59989 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2ISG3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 02:29:32 -0400
Date: Wed, 19 Sep 2012 07:29:27 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jim Lin <jilin@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] USB: EHCI: Tegra: Fix wrong register definition
Message-ID: <20120919062927.GB15492@kroah.com>
References: <1348026530-17327-1-git-send-email-jilin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348026530-17327-1-git-send-email-jilin@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 11:48:50AM +0800, Jim Lin wrote:
> Fix the issue that EHCI registers, hostpc[0] and usbmode_ex,
> are not correctly accessed on Tegra3 platform.
> 
> Signed-off-by: Jim Lin <jilin@nvidia.com>
> ---
> Changes in v2:
> - Modify array size for reserved4[] only.
> - Note that defining hostpc[0] is for a variable-length object.

Didn't I already apply V1 of this patch?  Can you now send me a fixup
given that the first patch had a problem?

thanks,

greg k-h
