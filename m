Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1ECXL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:11:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1ECXLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:11:23 -0400
Date: Tue, 3 May 2011 16:11:15 -0700
From: Greg KH <gregkh@suse.de>
To: wanlong.gao@gmail.com
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [resend PATCH] KernelDoc:Add the device driver-model structures
 to kerneldoc
Message-ID: <20110503231115.GA27014@suse.de>
References: <1304431649-5168-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304431649-5168-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 10:07:29PM +0800, wanlong.gao@gmail.com wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> 
> Hi Greg:
> I did the work again with your comments, please see the patch again now.
> 
> Thanks very much.
> Best regards
> 
> Wanlong Gao
> 
> Add the comments to the structure bus_type, device_driver, device,
> class for generating the driver-model kerneldoc.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Why did you add my signed-off-by: to this patch?  I did no such thing,
NEVER add someone's signed-off-by unless they really did so.

Despite that, the patch looks good to me as a great place to start out
with.  Randy, I'm sure you have some grammer and punctuation that could
be fixed up?

thanks,

greg k-h
