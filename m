Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab0D0LdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:33:23 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55188 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0D0LdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:33:21 -0400
Date: Tue, 27 Apr 2010 13:33:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Paolo Minazzi <paolo.minazzi@gmail.com>
Subject: Re: [PATCH 2/2] [MTD] Call bdi_init() and bdi_register()
Message-ID: <20100427113319.GJ27497@kernel.dk>
References: <20100426094810.GE27497@kernel.dk> <20100426143253.GB4364@logfs.org> <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk> <20100426163050.GC4364@logfs.org> <20100426163126.GD4364@logfs.org> <20100426170247.GP27497@kernel.dk> <20100426171236.GG4364@logfs.org> <20100427075229.GB27497@kernel.dk> <20100427112924.GB13859@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100427112924.GB13859@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27 2010, Jörn Engel wrote:
> On Tue, 27 April 2010 09:52:29 +0200, Jens Axboe wrote:
> > 
> > I cooked up that patch myself, here:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0661b1ac5d48eb47c8a5948c0554fea25e0895ab
> > 
> > Care to give it a quick spin?
> 
> Works for me.

Goodness, thanks for testing. Now we are pretty close to have something
we can send out.

-- 
Jens Axboe

