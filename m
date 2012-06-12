Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2FLVka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:40:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55431 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2FLVk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:40:29 -0400
Date: Tue, 12 Jun 2012 14:40:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk, fmhess@users.sourceforge.net
Subject: Re: [PATCH 2/8] staging: comedi: change type of num_subdevices
 parameter to comedi_alloc_subdevices
Message-ID: <20120612214025.GA4323@kroah.com>
References: <201206121157.27498.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206121157.27498.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 11:57:27AM -0700, H Hartley Sweeten wrote:
> From 606739d47df00ac9767e3256ab8f6eb1572bd429 Mon Sep 17 00:00:00 2001
> From: H Hartley Sweeten <hsweeten@visionengravers.com>
> Date: Tue, 12 Jun 2012 09:45:17 -0700
> Subject: [PATCH 2/8] staging: comedi: change type of num_subdevices parameter
>  to comedi_alloc_subdevices
> 
> The n_subdevices variable of struct comedi_device is an int type.
> Change the type of the comedi_alloc_subdevices 'num_subdevices' from
> an unsigned int to an int to match it.

Ok, some hints on how to send emails, don't do it this way :)

You need to use git send-email, which will not duplicate the From and
stuff in the body of the email.

Otherwise, I have to edit the patches by hand, or that information ends
up in the commit log for the patch:

-----------
commit c70c98a0180522411aff8eb87e10523eef2fe3f6
Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Tue Jun 12 11:57:27 2012 -0700

    staging: comedi: change type of num_subdevices parameter to comedi_alloc_subdevices
    
    From 606739d47df00ac9767e3256ab8f6eb1572bd429 Mon Sep 17 00:00:00 2001
    From: H Hartley Sweeten <hsweeten@visionengravers.com>
    Date: Tue, 12 Jun 2012 09:45:17 -0700
    Subject: [PATCH 2/8] staging: comedi: change type of num_subdevices parameter
     to comedi_alloc_subdevices
    
    The n_subdevices variable of struct comedi_device is an int type.
    Change the type of the comedi_alloc_subdevices 'num_subdevices' from
    an unsigned int to an int to match it.
    
    Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
    Cc: Ian Abbott <abbott@mev.co.uk>
    Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-------------

I'll edit up these 8, but in the future, please don't do that.

thanks,

greg k-h
