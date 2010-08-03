Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0HCBbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:31:19 -0400
Received: from kroah.org ([198.145.64.141]:43038 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0HCBbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:31:18 -0400
Date: Mon, 2 Aug 2010 18:30:14 -0700
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/1] staging: hv: Fix missing functions for
 net_device_ops (resubmit)
Message-ID: <20100803013013.GC3814@kroah.com>
References: <1FB5E1D5CA062146B38059374562DF7280E8556B@TK5EX14MBXC121.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7280E8556B@TK5EX14MBXC121.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 05:46:01PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Subject: staging: hv: Fix missing functions for net_device_ops
>   Unlike in older kernels, ether_setup() no longer sets default

Why put the subject in the body of the email?  This forces me to edit it
again :(

> functions. We need to put them into net_device_ops. For example,
> eth_change_mtu prevents setting MTU beyond 1500. This is necessary
> because we don't support jumbo frame at this time.

What does this mean?  Is it a bug?  Just not going as fast as possible?
Something else?

>   It affects kernel 2.6.32 and later, which are all versions
> containing Hyper-V drivers.

So is this fixing a bug that needs to be backported to these older
kernels (i.e. the staging tree?)  Is this something that is causing
people problems?

Third time's a charm?

thanks,

greg k-h
