Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0DEUnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:43:14 -0400
Received: from verein.lst.de ([213.95.11.210]:55575 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab0DEUnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:43:08 -0400
Date: Mon, 5 Apr 2010 22:42:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@samba.org>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raw: fsync method is now required
Message-ID: <20100405204208.GA4100@lst.de>
References: <20100404004523.GL5594@kryten> <20100405133902.082a6ef7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405133902.082a6ef7.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 01:39:02PM -0700, Andrew Morton wrote:
> So if you run fsync() against a /dev/rawX fd you get -EINVAL?  erk.
> 
> > We have two options: fix it or remove the raw driver completely. I'm happy
> > to do either, the fact this has been broken for so long suggests it is
> > rarely used.
> 
> Well.  It shows that fsync() is rarely used.

The new O_SYNC implementation uses fsync, so O_SYNC users are also
affected now.  Still shows that either one is relatively rarely used..

