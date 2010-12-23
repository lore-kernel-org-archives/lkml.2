Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab0LWQNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 11:13:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48241 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0LWQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 11:13:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sA4jWoEnwOd8azrJjBPFpXDvenoRsCvjaGbifG9CbayKibv9Aq4oqzY3o7ILorAiPz
         sLkTAwvO9UeO6i19ztYiS19M9nQwonaDwpm8AH/Lm/984QiI5ShcLhNqlOoHL3KHBq+/
         UfkclXoboDq7i7ayGWi3wRTG+/kqeeanLdidE=
Date: Thu, 23 Dec 2010 17:13:12 +0100
From: Tejun Heo <htejun@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Boot failure with block/for-next
Message-ID: <20101223161312.GC18482@htj.dyndns.org>
References: <1293038823.3019.89.camel@mulgrave.site>
 <1293078673.3019.765.camel@mulgrave.site>
 <20101223100956.GA15625@htj.dyndns.org>
 <1293118041.3029.3.camel@mulgrave.site>
 <20101223155239.GB18482@htj.dyndns.org>
 <1293120614.7776.0.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293120614.7776.0.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 10:10:14AM -0600, James Bottomley wrote:
> > Can you please apply the debug patch I posted in the other message and
> > post the boot log?  Let's see how the partition read is failing.
> 
> That's actually a red herring ... the disk isn't spinning up, so the
> partition read is getting a not ready.

Oh, yay, but at any rate I think the don't-clear-media-presence patch
is probably a good idea just in case UA gets reported somehow.

Thanks.

-- 
tejun
