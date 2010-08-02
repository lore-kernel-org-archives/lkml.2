Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0HBRSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:18:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab0HBRSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:18:06 -0400
Date: Mon, 2 Aug 2010 10:17:54 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/1] staging: hv: Fix missing functions for
 net_device_ops
Message-ID: <20100802171754.GA8213@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7280E8547C@TK5EX14MBXC121.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7280E8547C@TK5EX14MBXC121.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 05:00:33PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Subject: staging: hv: Fix missing functions for net_device_ops
>   Unlike in older kernels, ether_setup() no longer sets default
> functions.

So what kernel versions are affected by this?

Please don't attach a patch and put it inline, it forces me to edit it
by hand.

Care to provide the above information and resend it so I can apply it?

thanks,

greg k-h
