Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2GQCa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:30:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59959 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab2GQCay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:30:54 -0400
Date: Mon, 16 Jul 2012 19:30:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk
Subject: Re: [PATCH] staging: comedi: adl_pci6208: use the comedi_device
 hw_dev to hold the pci_dev
Message-ID: <20120717023050.GA3025@kroah.com>
References: <201207161926.22725.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207161926.22725.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 07:26:22PM -0700, H Hartley Sweeten wrote:
> Use the 'struct device *hw_dev' variable in the comedi_device struct
> to hold the pci_dev instead of carrying it in the private data.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/comedi/drivers/adl_pci6208.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

Looks good to me, I forgot we had the to_pci_dev() macro in pci.h.  Want
to redo all of these and resend this one with the larger series?

thanks,

greg k-h
