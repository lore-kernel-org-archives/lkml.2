Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1AGTqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:46:05 -0500
Received: from kroah.org ([198.145.64.141]:49449 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab1AGTqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:46:02 -0500
Date: Fri, 7 Jan 2011 11:37:33 -0800
From: Greg KH <greg@kroah.com>
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Weber <weber@corscience.de>, Johannes Reif <reif@corscience.de>,
        changgx <changgx@163.com>, miguelangel@nbee.es
Subject: Re: [PATCH resend 2] Add sc16is7x2 driver
Message-ID: <20110107193733.GC18309@kroah.com>
References: <4D272DDA.6010007@iis.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D272DDA.6010007@iis.fraunhofer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 04:14:34PM +0100, Manuel Stahl wrote:
> IRQ is now implemented with work queue (like max3100).
> The problem is, that the sc16is7x2 has a low active irq. But with
> active low threaded_irqs, shared irqs are not allowed.
> 
> Please try this one and report errors.
> 
> Regards,
> Manuel Stahl
> 
> PS: sorry that the patch is not inline, not sure how to configure
> thunderbird correctly

Don't sign your emails, and that will help out in getting 'git am' to be
able to accept this.

Care to retry with the signature?

> --- /dev/null
> +++ b/include/linux/serial_sc16is7x2.h

This should go in include/linux/platform_data/ instead of the "main"
include/linux/ directory.

thanks,

greg k-h
