Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2K1AjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:39:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2K1AjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:39:02 -0500
Date: Tue, 27 Nov 2012 16:40:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: djbw@fb.com, vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jon.mason@intel.com
Subject: Re: [PATCH v2] ioat: remove chanerr mask setting for IOAT v3.x
Message-ID: <20121128004028.GA3857@kroah.com>
References: <20121127221608.11315.49374.stgit@djiang5-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127221608.11315.49374.stgit@djiang5-linux.ch.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 03:16:08PM -0700, Dave Jiang wrote:
> The existing code set a value in the PCI_CHANERRMSK_INT register
> for a workaround to address a pre-silicon bug on the Intel 5520 IO hub that
> has been fixed when the hardware was released. There is no need for this
> code.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
>  drivers/dma/ioat/dma_v3.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
