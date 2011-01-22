Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab1AVUZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 15:25:52 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49015 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1AVUZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 15:25:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=j2cSFT4HmjO+JxxLoUZaEp+Zlc9NuCdkUVOVO/yQZXmPbXwyvDgAOzFus4YelQu2Xn
         EBJTB1SwXbw/tAkndjeHUKq9IcWk1aZaE/Vyfsg43avA/1UzjgpRFVRf/Q45gPh+dIUd
         3EJdYjFTBXCM9cawhRkVxMVQsGms56XXRYbok=
Date: Sat, 22 Jan 2011 22:17:09 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers: remove aio.h from sched.h
Message-ID: <20110122201709.GA4691@p183.telecom.by>
References: <20110122150315.GA26270@p183.telecom.by>
 <AANLkTi=TOo=u+wz7GEDZfPnOoV3VywOrf46yPK7wLykT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=TOo=u+wz7GEDZfPnOoV3VywOrf46yPK7wLykT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 03:31:19PM +0000, Will Newton wrote:
> On Sat, Jan 22, 2011 at 3:03 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > --- a/block/scsi_ioctl.c
> > +++ b/block/scsi_ioctl.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/cdrom.h>
> >  #include <linux/slab.h>
> >  #include <linux/times.h>
> > +#include <linux/uio.h>
> >  #include <asm/uaccess.h>
> >
> >  #include <scsi/scsi.h>
> 
> Should this be aio.h?
> 
> There's a few more instances of uio,h elsewhere in the patch.

No. It's for "struct iovec" specifically.
