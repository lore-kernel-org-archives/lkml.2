Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1EZHJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 03:09:18 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44070 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606Ab1EZHJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 03:09:16 -0400
X-Sasl-enc: UJqR6iqggDoZJXryKlvVA95W01PXNj+Da0ABTgzGXdFD 1306393754
Date: Thu, 26 May 2011 00:02:39 -0700
From: Greg KH <greg@kroah.com>
To: Konrad@dumpdata.com, Rzeszutek@dumpdata.com, Wilk@dumpdata.com
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] Xen bug-fixes for 2.6.39 (already in 2.6.40)
Message-ID: <20110526070239.GB29833@kroah.com>
References: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 05:37:32PM -0400, Konrad@dumpdata.com wrote:
> Hey stable-tree maintainer(s).
> 
> The follow four patches are in the 2.6.40 tree and should be back-ported to 2.6.39 (only).
> I forgot to CC:stable on them, so manually doing it here.
> 
> The four patches in question have the following git commits:
> 
> 8c5950881c3b5e6e350e4b0438a8ccc513d90df9
>     xen/p2m: Create entries in the P2M_MFN trees's to track 1-1 mappings
> 0f16d0dfcdb5aab97d9e368f008b070b5b3ec6d3
>     xen/setup: Fix for incorrect xen_extra_mem_start initialization under 32-bit
> 15bfc094517db2ddf38ca7ed47f3a1c0ad24f7c4
>     xen/setup: Ignore E820_UNUSABLE when setting 1-1 mappings.
> 7899891c7d161752f29abcc9bc0a9c6c3a3af26c
>     xen mmu: fix a race window causing leave_mm BUG()
> 
> And are part of this email chain. Please apply them to 2.6.39.1 tree.

I need an ack from the Xen maintainer and the original patch author
before I can accept these.  Please get them to provide this and I will
be glad to queue them up.

thanks,

greg k-h
