Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0JERpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:45:41 -0400
Received: from kroah.org ([198.145.64.141]:50580 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab0JERpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:45:40 -0400
Date: Tue, 5 Oct 2010 10:42:00 -0700
From: Greg KH <greg@kroah.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.name>,
        stable@kernel.org, Alan Ott <alan@signal11.us>
Subject: Re: [stable] [PATCH 0/2] HID: hidraw, fix two NULL pointer
 dereferences
Message-ID: <20101005174200.GB29937@kroah.com>
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>
 <1286292017-6746-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286292017-6746-1-git-send-email-ospite@studenti.unina.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 05:20:15PM +0200, Antonio Ospite wrote:
> Hi,
> 
> here are some fixes to hidraw.
> 
> Patches are against 2.6.36-rc6, but they should be ported to other
> maintained stable kernels as well.
> 
> Antonio Ospite (2):
>   HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
>   HID: hidraw, fix a NULL pointer dereference in hidraw_write
> 
>  drivers/hid/hidraw.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> 
> The first one has been sent already but I am resending it with
> stable@stable@kernel.org in the recipients list.

Please read Documentation/stable_kernel_rules.txt which shows you how to
properly notify the stable developer to pick up the patch (hint, cc:ing
them on the patch is not the correct way, you need to add the mark to
the signed-off-by: area.)

thanks,

greg k-h
