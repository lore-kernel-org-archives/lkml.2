Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1ASEbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 23:31:03 -0500
Received: from kroah.org ([198.145.64.141]:58137 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1ASEbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 23:31:00 -0500
Date: Tue, 18 Jan 2011 20:31:27 -0800
From: Greg KH <greg@kroah.com>
To: Sutharsan Ramamoorthy <sutharsan.ramamoorthy@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        david.cross@cypress.com, srmt@cypress.com
Subject: Re: [PATCH] Westbridge software module, fixes errors reported by
 checkpatch.pl
Message-ID: <20110119043127.GC25787@kroah.com>
References: <792204.57037.qm@web121606.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <792204.57037.qm@web121606.mail.ne1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 03:59:09PM -0800, Sutharsan Ramamoorthy wrote:
> From: Sutharsan Ramamoorthy <srmt@cypress.com>
> 
> This patch fixes errors in westbridge device controller driver in the 
> staging tree reported by checkpatch.pl. File containing EXPORT_SYMBOL() 
> macros for all the API's exported by the westbridge software has been 
> removed. EXPORT_SYMBOL() macro's are added after the functions being 
> exported. This patch also fixes some function prototype definitions and 
> removes new typdefs.

Care to split this into two patches?  Every patch should only do one
thing at a time.

> +struct cyasdevice {
>          /* Handle to the Antioch device */
>          cy_as_device_handle            dev_handle;
>          /* Handle to the HAL */
>          cy_as_hal_device_tag            hal_tag;
>          spinlock_t      common_lock;
>          unsigned long flags;
> -} cyasdevice;
> +} ;

What's with the extra space here?

thanks,

greg k-h
