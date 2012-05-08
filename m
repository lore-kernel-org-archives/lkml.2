Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab2EHWzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:55:19 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50794 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755341Ab2EHWzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:55:17 -0400
X-Sasl-enc: PXhgj+N0fam5DRA6ov1B5TqEu20ZJ5hdoBauYubhHIoU 1336517716
Date: Tue, 8 May 2012 15:55:15 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] device core: fix a copy-paste error
Message-ID: <20120508225515.GD7948@kroah.com>
References: <Pine.LNX.4.44L0.1205081507010.1164-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1205081507010.1164-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 03:08:45PM -0400, Alan Stern wrote:
> This patch (as1552) fixes a fairly obvious copy-paste error that could
> have serious consequences on architectures where sizeof(int) !=
> sizeof(unsigned long).
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: <stable@vger.kernel.org>
> 
> ---
> 
> This just caught my eye while I was adding another macro immediately
> below DEVICE_INT_ATTR.
> 
> 
>  include/linux/device.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This is already fixed up in my driver-core-next tree from a patch from
Michael Davidson <md@google.com>.

sorry,

greg k-h
