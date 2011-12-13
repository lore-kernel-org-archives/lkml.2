Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab1LMTMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:12:33 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43136 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104Ab1LMTMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:12:30 -0500
X-Sasl-enc: UX/dWJ+t+4Y4h//D+DUhzoJ/mbBtacEBUdnqVY3gPqYx 1323803549
Date: Tue, 13 Dec 2011 11:11:25 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
Subject: Re: [PATCH 1/3] kref: Inline all functions
Message-ID: <20111213191125.GA3797@kroah.com>
References: <20111210104341.592561407@chello.nl>
 <20111210104840.107647845@chello.nl>
 <20111212221159.GA27940@kroah.com>
 <1323768980.9082.6.camel@twins>
 <20111213171511.GA17096@kroah.com>
 <1323802323.9082.20.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323802323.9082.20.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 07:52:03PM +0100, Peter Zijlstra wrote:
> On Tue, 2011-12-13 at 09:15 -0800, Greg KH wrote:
> 
> > > ---
> > >  include/linux/kref.h |   80 +++++++++++++++++++++++++++++++++++++++---
> > >  lib/Makefile         |    2 -
> > >  lib/kref.c           |   97 ---------------------------------------------------
> > >  3 files changed, 76 insertions(+), 103 deletions(-)
> > > Index: linux-2.6/include/linux/kref.h
> > > ===================================================================
> > 
> > What's this stuff for, we aren't using cvs anymore :)
> 
> Dunno, it looks like quilt generates that for me.

You need to put:
QUILT_REFRESH_ARGS="--diffstat --strip-trailing-whitespace --no-timestamps --no-index --sort -p1 -p ab"
QUILT_DIFF_ARGS="--no-timestamps --no-index --sort --color=auto -p ab"

into your .quiltrc so the index markings will not show up, as well as
using some other "sane" defaults for generating patches.

greg k-h
