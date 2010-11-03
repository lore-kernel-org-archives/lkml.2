Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab0KCTMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:12:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38549 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab0KCTMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Zs9aHYIJAvqMXV0ovpJ8S/t5LYflnRz0eQmKXK/vDaFcAAAr59VKDzbtQOPvZAh1vJ
         1UNPsbKFqH8yyNZwGXd2wWtVUTrBiK/0dR/QRO3+LaZBkgosUZDVlUVmRSc9umutJHp9
         pI0T1aYW+Hknf7NONieHVbbVQAhJzCoes4PZ0=
Date: Wed, 3 Nov 2010 21:12:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Andy Whitcroft <apw@canonical.com>, Rahul Ruikar <rahul.ruikar@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: gadget: goku_udc: add registered flag bit
Message-ID: <20101103191238.GI14069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg KH <gregkh@suse.de>, Andy Whitcroft <apw@canonical.com>,
	Rahul Ruikar <rahul.ruikar@gmail.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1288807358-11813-1-git-send-email-apw@canonical.com> <20101103182314.GA8010@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103182314.GA8010@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 11:23:14AM -0700, Greg KH wrote:
> On Wed, Nov 03, 2010 at 06:02:38PM +0000, Andy Whitcroft wrote:
> > The commit below cleaned up error handling, in part by introducing a
> > registered flag bit.  This however was not added to the device
> > structure leding to build failures:
> > 
> >   commit 319feaabb6c7ccd90da6e3207563c265da7d21ae
> >   Author: Dan Carpenter <error27@gmail.com>
> >   Date:   Tue Oct 5 18:55:34 2010 +0200
> > 
> >     usb: gadget: goku_udc: Fix error path
> > 
> > Add the missing registered flag bit.
> 
> 
> Dan, is this patch below the correct fix?  Or should we be looking at
> some other flag?
> 

Yes.  This was my fault.  I forgot to send you that part of the patch.

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter
