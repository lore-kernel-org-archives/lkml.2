Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0ITCv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 22:51:26 -0400
Received: from cobra.newdream.net ([66.33.216.30]:52117 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0ITCvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 22:51:25 -0400
Date: Sun, 19 Sep 2010 19:53:08 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Farnum <gregf@hq.newdream.net>
Subject: Re: linux-next: build failure after merge of the ceph tree
In-Reply-To: <20100920114136.33d75323.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1009191952540.7498@cobra.newdream.net>
References: <20100920114136.33d75323.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Stephen Rothwell wrote:
> Hi Sage,
> 
> After merging the vfs tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> net/ceph/pagelist.c: In function 'ceph_pagelist_truncate':
> net/ceph/pagelist.c:136: error: implicit declaration of function 'pagelist_unmap_tail'
> 
> Caused by commit d73f8eefea20406cba00b80a65747844df120559 ("ceph: add pagelist_reserve, pagelist_truncate, pagelist_set_cursor").
> 
> I have used the version of the ceph tree from next-20100917 for today.

Fixed.  Thanks!

sage
