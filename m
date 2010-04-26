Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab0DZRIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:08:54 -0400
Received: from lazybastard.de ([212.112.238.170]:47714 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0DZRIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:08:53 -0400
Date: Mon, 26 Apr 2010 19:08:40 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Paolo Minazzi <paolo.minazzi@gmail.com>
Subject: Re: [PATCH 1/2] [MTD] Move mtd_bdi_*mappable to mtdcore.c
Message-ID: <20100426170840.GF4364@logfs.org>
References: <20100422162709.GJ27497@kernel.dk> <20100422203358.GB30749@logfs.org> <20100423100532.GN27497@kernel.dk> <20100423205518.GB7008@logfs.org> <20100426094810.GE27497@kernel.dk> <20100426143253.GB4364@logfs.org> <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk> <20100426163050.GC4364@logfs.org> <20100426170128.GO27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100426170128.GO27497@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 April 2010 19:01:28 +0200, Jens Axboe wrote:
> On Mon, Apr 26 2010, Jörn Engel wrote:
> > 
> > diff --git a/drivers/mtd/devices/drais.c b/drivers/mtd/devices/drais.c
> > index b93ff3f..6f81b28 100644
> > --- a/drivers/mtd/devices/drais.c
> > +++ b/drivers/mtd/devices/drais.c
> > @@ -33,7 +33,7 @@
> >  #include <linux/sched.h>
> >  #include "drais.h"
> >  
> > -#undef DEBUG_ERASE
> > +#define DEBUG_ERASE
> 
> Leftover debugging?

Yes.  Can you just remove that hunk or should I resend?

Jörn

-- 
"Error protection by error detection and correction."
-- from a university class
