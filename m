Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1CIV2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:28:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:41910 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab1CIV2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:28:02 -0500
Date: Wed, 9 Mar 2011 13:27:35 -0800
From: Greg KH <gregkh@suse.de>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3][RESEND] Check for immutable/append flag in fallocate
 path
Message-ID: <20110309212735.GB27747@suse.de>
References: <4D6221B8.9040303@gmail.com>
 <4D6F5473.2070709@gmail.com>
 <4D720469.1010101@gmail.com>
 <AANLkTinyK0G=tfZob4u7XBj7Gna3FbZnLrqswz2oajwn@mail.gmail.com>
 <4D720C0B.1050300@gmail.com>
 <4D77D821.7090003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D77D821.7090003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 08:42:25PM +0100, Marco Stornelli wrote:
> Il 05/03/2011 11:10, Marco Stornelli ha scritto:
> > From: Marco Stornelli <marco.stornelli@gmail.com>
> > 
> > In the fallocate path the kernel doesn't check for the immutable/append
> > flag. It's possible to have a race condition in this scenario: an
> > application open a file in read/write and it does something, meanwhile
> > root set the immutable flag on the file, the application at that point
> > can call fallocate with success. In addition, we don't allow to do any
> > unreserve operation on an append only file but only the reserve one.
> > 
> > Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Al, can you apply this patch please? I add Greg in cc, because maybe he
> could be interested about stable tree.

Please read Documentation/stable_kernel_rules.txt for how to get patches
into stable kernel releases (hint, emailing me like this is not the way
to do it...)

thanks,

greg k-h
