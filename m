Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab2KPAat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 19:30:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61155 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2KPAar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 19:30:47 -0500
Date: Thu, 15 Nov 2012 16:30:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH v5 2/2] net: Add support for NTB virtual ethernet device
Message-ID: <20121116003043.GC20876@kroah.com>
References: <1352160669-4330-1-git-send-email-jon.mason@intel.com>
 <1352160669-4330-3-git-send-email-jon.mason@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352160669-4330-3-git-send-email-jon.mason@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 05:11:09PM -0700, Jon Mason wrote:
> A virtual ethernet device that uses the NTB transport API to
> send/receive data.
> 
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  MAINTAINERS              |    1 +
>  drivers/net/Kconfig      |    4 +
>  drivers/net/Makefile     |    1 +
>  drivers/net/ntb_netdev.c |  415 ++++++++++++++++++++++++++++++++++++++++++++++

As I haven't taken the core yet, I can't take this.  But even then, I
would need an ack from the network maintainers before I could.

And are you sure this is in the correct location in the tree?

thanks,

greg k-h
