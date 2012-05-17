Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab2EQCSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 22:18:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51727 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760826Ab2EQCSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 22:18:11 -0400
Date: Wed, 16 May 2012 19:18:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk
Subject: Re: [PATCH] staging: comedi: Convert struct addi_board
 initialization to C99 format
Message-ID: <20120517021805.GA32592@kroah.com>
References: <201205161751.56913.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205161751.56913.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 05:51:56PM -0700, H Hartley Sweeten wrote:
> Convert the struct addi_board initialization to C99 format and remove
> all the NULL or 0 initializers. This makes maintaining and editing the
> code simpler and less error prone.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Mori Hess <fmhess@users.sourceforge.net>
> 
> ---
> 
> This patch is a bit large but should be easy enough to review.
> It does incease the size of the source file in bytes but it reduces
> the lines of code by 1103 lines.
> 
> There are 6 checkpatch warnings about lines over 80 characters
> due to the long CamelCase names for some of the functions.
> "Fixing" these actually hurts the readability of the code. The
> checkpatch warnings will be addressed later by renaming the
> CamelCase functions.

Nice job, this driver is a pain to read...

greg k-h
