Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0GKJts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 05:49:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46381 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0GKJtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 05:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NgeSiW1JABhI+UBUZB3qzf/UUaQv3t1+wZkit7ikIvOfeOi0Sy+UVstsdxqYnc1Ugy
         On7UB3W1/swxdxzQOxSFLLxMH17QZFtiyyd3lYJG7xepALs29C2TgTgghbrRl4QrQOGb
         gYkSWAKx2jMIwZeq75TsDazzv0+FhDyTgoNDk=
Subject: Re: [PATCH] Staging: dt3155: fix coding style issues in
 dt3155_drv.c
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>, devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100708200018.GC3530@kroah.com>
References: <1278435198.5396.73.camel@dermezel>
	 <20100708200018.GC3530@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 11:49:31 +0200
Message-ID: <1278841771.16713.1.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 13:00 -0700, Greg KH wrote:
> On Tue, Jul 06, 2010 at 06:53:18PM +0200, Joe Eloff wrote:
> > I just realised how the commit chaining works after messing it up so I have already 
> > uploaded a 1/2 and 2/2 and now it made another 2/2 for this patch which is different.
> > 
> > I have realised how it works now and wont mess it up again and have no idea how to reverse chain the
> > 3 patches.
> > 
> > This now fixes up all checkpatch.pl issues bar 1.
> 
> This doesn't apply either :(
> 
> care to redo all of these against the latest linux-next?
> 
> thanks,
> 
> greg k-h

Will redo all against latest tree :(. 

Did patches over 3 days, is that why it did not take?

Will get up to date and apply the patches again and send.

Regards,

Joe

