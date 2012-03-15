Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030719Ab2COPKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:10:36 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47511 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965190Ab2COPKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:10:33 -0400
Date: Thu, 15 Mar 2012 08:10:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the tty tree with the xen-two tree
Message-ID: <20120315151027.GJ7928@kroah.com>
References: <20120315163740.c51aed0e3c10234fa3f37a46@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315163740.c51aed0e3c10234fa3f37a46@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 04:37:40PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/hvc/hvc_xen.c between commits 02e19f9c7cac ("hvc_xen:
> implement multiconsole support") and cf8e019b523a ("hvc_xen: introduce
> HVC_XEN_FRONTEND") from the xen-two tree and commit d4e33fac2408
> ("serial: Kill off NO_IRQ") from the tty tree.
> 
> The code was moved around.  I fixed it up (see below) and can carry the
> fix as necessary.

Thanks, this looks good.

greg k-h
