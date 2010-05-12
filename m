Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab0ELVjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:39:47 -0400
Received: from kroah.org ([198.145.64.141]:44533 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218Ab0ELVjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:39:42 -0400
Date: Wed, 12 May 2010 14:39:38 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Viral Mehta <Viral.Mehta@lntinfotech.com>, linux-kernel@vger.kernel.org,
       Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH] USB: gadget: f_mass_storage: fix in error recovery
Message-ID: <20100512213938.GA27648@kroah.com>
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck4q0c87p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABC@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck7aofj7p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABF@VSHINMSMBX01.vshodc.lntinfotech.com>
 <1148fb1fcb3a9864a2a12fbbf2e3444827c9ed4a.1273661077.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1148fb1fcb3a9864a2a12fbbf2e3444827c9ed4a.1273661077.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 12:51:13PM +0200, Michal Nazarewicz wrote:
> In to places in fsg_common_init() an unconditional call to kfree()
> on common was performed in error recovery which is not a valid
> behaviour since fsg_common structure is not always allocated by
> fsg_common_init().
> 
> To fix, the calls has been replaced with a goto to a proper error
> recovery which does the correct thing.
> 
> Also, refactored fsg_common_release() function.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

Does this superseed your previous patch in this thread?

thanks,

greg k-h
