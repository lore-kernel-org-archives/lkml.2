Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0HCJh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:37:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58796 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0HCJh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nhq7+VtCqtJlvvhgqYAh3cGU7eJocw/y1Hr8uyHdzrJ2zSLHwBYFRhzsswyMMFuTc4
         9dLLAu1+IJgbuiHTu5MsX2DT+4YufhAvN0tFe8Foo8aG/x3NdDGxgJOFsgyLYCVDWlB8
         J9vWbEZsLjQHoaLEn+kb+h38FTHS8tD2f87Xg=
Date: Tue, 3 Aug 2010 18:37:50 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] writeback: remove wb in get_next_work_item
Message-ID: <20100803093750.GA9942@barrios-desktop>
References: <1280673774-8072-1-git-send-email-minchan.kim@gmail.com>
 <20100802124739.GA22345@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802124739.GA22345@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 02:47:39PM +0200, Christoph Hellwig wrote:
> On Sun, Aug 01, 2010 at 11:42:54PM +0900, Minchan Kim wrote:
> > 83ba7b07 cleans up the writeback.
> > So we don't use wb any more in get_next_work_item.
> > Let's remove unnecessary argument.
> 
> If we can get it in this merge windows it's fine with me.  If not I have
> patches pending that use only the bdi_writeback inside fs/fs-writeback.c
> and completely get rid of the backing-dev.
> 

Yub. I don't care about it.
It's just clean up patch not urgent. 


-- 
Kind regards,
Minchan Kim
