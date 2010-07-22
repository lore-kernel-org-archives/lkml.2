Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0GVXBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:01:25 -0400
Received: from kroah.org ([198.145.64.141]:50782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab0GVXBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:01:24 -0400
Date: Thu, 22 Jul 2010 16:00:41 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Lytochkin Boris <lytboris@gmail.com>
Subject: Re: [PATCH] serial: add support for OX16PCI958 card
Message-ID: <20100722230041.GA1003@kroah.com>
References: <1279786363-16813-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279786363-16813-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 12:12:43PM +0400, Alexander Beregalov wrote:
> From: Lytochkin Boris <lytboris@gmail.com>
> 
> Signed-off-by: Lytochkin Boris <lytboris@gmail.com>
> Tested-by: Lytochkin Boris <lytboris@gmail.com>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
>  drivers/serial/8250_pci.c |   12 ++++++++++++
>  include/linux/pci_ids.h   |    1 +

Please read the top of pci_ids.h for why we don't want to add new values
there.

Care to fix that up and resend this?

thanks,

greg k-h
