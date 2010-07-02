Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab0GBHFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:05:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48222 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0GBHE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l/NzNTOuIgGtZWORdtT63yuG2/qXeoKfQVMQMfavfQJS/vU6/fsW9YvRiRoYU4zahY
         c3JS0WFQVSQokfx9+xL/5COKLBqIfYiYvsP0JqAdUhfmNOxXhwFswH6CU0geToHtSKgy
         rYxSzDaeL9zOTUFuj06Xr27CiT2UBFMaXYokw=
Date: Fri, 2 Jul 2010 11:04:54 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Doug Gilbert <dgilbert@interlog.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/25] scsi/sg: remove casts from void*
Message-ID: <20100702070454.GA24442@shinshilla>
References: <1277990204-22157-1-git-send-email-segooon@gmail.com>
 <20100701173805.GW19184@bicker>
 <20100701182724.GA22466@shinshilla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701182724.GA22466@shinshilla>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 22:27 +0400, Kulikov Vasiliy wrote:
> The problem is that this driver is not even compileable.
Forget about this.
staging/wlags49_h2/wl_pci.c is not compileable, not scsi/sg.c :)
