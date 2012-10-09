Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2JISZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:25:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab2JISZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:25:40 -0400
Date: Tue, 9 Oct 2012 11:25:31 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 1/5] aio: Kill return value of aio_complete()
Message-ID: <20121009182531.GL26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349764760-21093-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:39:16PM -0700, Kent Overstreet wrote:
> Nothing used the return value, and it probably wasn't possible to use it
> safely for the locked versions (aio_complete(), aio_put_req()). Just
> kill it.

Nice, seems reasonable enough.  (Queue the timer for complaints from out
of tree code?)

Acked-by: Zach Brown <zab@redhat.com>

Though, in the future please cc: aio patches to the maintainers.  I'd
have missed this if I wasn't sifting through lkml:

$ ./scripts/get_maintainer.pl -f fs/aio.c
Benjamin LaHaise <bcrl@kvack.org> (supporter:AIO)
Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS...)
linux-aio@kvack.org (open list:AIO)
linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS...)
linux-kernel@vger.kernel.org (open list)

- z
