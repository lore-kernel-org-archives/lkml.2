Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0DUPsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:48:46 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53602 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab0DUPsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:48:45 -0400
Date: Wed, 21 Apr 2010 17:48:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Divyesh Shah <dpshah@google.com>, Nauman Rafique <nauman@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH V2] blkio: Fix blkio crash during rq stat update
Message-ID: <20100421154843.GX27497@kernel.dk>
References: <20100421153623.GD3275@redhat.com> <20100421154101.GV27497@kernel.dk> <20100421154127.GW27497@kernel.dk> <20100421154717.GE3275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421154717.GE3275@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21 2010, Vivek Goyal wrote:
> On Wed, Apr 21, 2010 at 05:41:28PM +0200, Jens Axboe wrote:
> > On Wed, Apr 21 2010, Jens Axboe wrote:
> > > On Wed, Apr 21 2010, Vivek Goyal wrote:
> > > > @@ -1001,6 +1002,11 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
> > > >  	return cfqg;
> > > >  }
> > > >  
> > > > +static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg) {
> > > > +	atomic_inc(&cfqg->ref);
> > > > +	return cfqg;
> > > > +}
> > > > +
> > > 
> > > Sorry to keep harping on this - style is still wrong, and:
> > 
> > I'll fix these up by hand.
> 
> Thanks Jens. Sorry for the trouble.

No problem, it's now committed. Thanks for fixing it.

-- 
Jens Axboe

