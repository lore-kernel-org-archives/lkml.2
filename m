Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab1IBXMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:12:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab1IBXMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:12:13 -0400
Date: Sat, 3 Sep 2011 01:12:12 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2 v3] Small cleanup of bdi_forker_thread()
Message-ID: <20110902231212.GH12182@quack.suse.cz>
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
 <4E61619E.8040105@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E61619E.8040105@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-09-11 17:07:10, Jens Axboe wrote:
> On 2011-09-02 16:54, Jan Kara wrote:
> > 
> >   Hi Jens,
> > 
> >   so after I realized how I underestimated subtlety of bdi_forker_thread()
> > here are two small cleanups to it. The first one puts clearing of BDI_pending
> > in a more natural place, the second patch adds a comment so that fools like
> > me don't try to optimize the function in a wrong place...
> 
> Thanks Jan, I've queued it up for 3.1. I've marked it as stable, looks
> like we need it from 2.6.36 and above.
  Thanks. But is it really a stable material? It's just a cleanup after
all...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
