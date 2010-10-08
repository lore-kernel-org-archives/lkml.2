Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab0JHORd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:17:33 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:33563 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752942Ab0JHORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:17:32 -0400
Date: Sat, 9 Oct 2010 01:17:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101008141728.GH4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008134315.GA14807@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008134315.GA14807@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 09:43:15AM -0400, Christoph Hellwig wrote:
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 1162c10..34f983f 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -383,6 +383,7 @@ struct inodes_stat_t {
> >  #include <linux/capability.h>
> >  #include <linux/semaphore.h>
> >  #include <linux/fiemap.h>
> > +#include <linux/rculist_bl.h>
> 
> rculist_bl.h doesn't actually exist anymore in your tree, so this needs
> to be list_bl.h to actually compile.

/me is confused.

rculist_bl.h doesn't exist in my tree, that include does, yet
everything compiles.

<shrug>

Fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
