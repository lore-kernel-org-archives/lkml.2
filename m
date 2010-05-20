Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0ETLob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:44:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36551 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab0ETLoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:44:30 -0400
To: Jens Axboe <jens.axboe@oracle.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-reply-to: <20100520112821.GP25951@kernel.dk> (message from Jens Axboe on
	Thu, 20 May 2010 13:28:22 +0200)
Subject: Re: [RFC PATCH] fuse: support splice() reading from fuse device
References: <E1OF3kc-00084X-Hi@pomaz-ex.szeredi.hu> <20100520112821.GP25951@kernel.dk>
Message-Id: <E1OF4Ak-00088m-Jm@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 20 May 2010 13:44:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Jens Axboe wrote:
> On Thu, May 20 2010, Miklos Szeredi wrote:
> > This continues zero copy I/O support on the fuse interface.  The first
> > part of the patchset (splice write support on fuse device) was posted
> > here:
> > 
> >   http://lkml.org/lkml/2010/4/28/215
> > 
> > With Jens' pipe growing patch and additional fuse patches it was
> > possible to achieve a 20GBytes/s write throghput on my laptop in a
> > "null" filesystem (no page cache, data goes to /dev/null).
> 
> Do you have some numbers on how that compares to the same test with the
> default 16 page pipe size?

With the default 64k pipe size it's about 4 times slower than with a
pipe size of 1MB.

Miklos
