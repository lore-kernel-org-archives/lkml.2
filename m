Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab2IDSgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:36:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33830 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2IDSgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:36:05 -0400
Date: Tue, 4 Sep 2012 11:33:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk, dan.carpenter@oracle.com
Subject: Re: [PATCH] staging: comedi: remove pointer math for subdevice access
Message-ID: <20120904183333.GA31939@kroah.com>
References: <201208201659.16987.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208201659.16987.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 04:59:16PM -0700, H Hartley Sweeten wrote:
> Convert all the comedi_subdevice pointer access from pointer
> math to array access.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>

This patch doesn't seem to apply, care to break it up into smaller
pieces, and also fold in your "fix the build" patch as well?  That way
we have a chance to get it applied :)

thanks,

greg k-h
