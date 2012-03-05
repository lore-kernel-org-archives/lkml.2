Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2CEQxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:53:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50489 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab2CEQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:53:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.125.195 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 5 Mar 2012 08:45:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: bhelgaas@google.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/1 v3] PCI: Device specific reset function
Message-ID: <20120305164518.GF2459@kroah.com>
References: <4f548ed1.4o6PhHmCeKTSPZXU%tadeusz.struk@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f548ed1.4o6PhHmCeKTSPZXU%tadeusz.struk@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 10:00:49AM +0000, Tadeusz Struk wrote:
> 
> ---
>  drivers/pci/pci.h    |    1 +
>  drivers/pci/quirks.c |   33 +++++++++++++++++++++++++++------
>  include/linux/pci.h  |    1 +
>  3 files changed, 29 insertions(+), 6 deletions(-)

Please read Documentation/SubmittingPatches for how to properly create,
and send, patches that are in a format that can be accepted.

Hint, also run your patch through scripts/checkpatch.pl to find the
obvious problems that are in it, to keep us from having to do that for
you...

> 
> This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.

I have been told that such email footers require that the patch be
deleted and never be accepted.  Please fix this if you expect your
patches to be able to be applied.

greg k-h
