Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0GFAq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:46:26 -0400
Received: from cynthia.allandria.com ([76.245.85.235]:39027 "EHLO
	cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0GFAqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:46:25 -0400
Date: Mon, 5 Jul 2010 17:45:50 -0700
From: Brad Boyer <flar@allandria.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] new stat*fs-like syscall?
Message-ID: <20100706004550.GC12517@cynthia.pants.nu>
References: <20100624131455.GA10441@laptop> <7897.1277531612@jrobl> <20100626093544.GA27715@infradead.org> <13226.1277556884@jrobl> <20100705205806.GA12517@cynthia.pants.nu> <6419.1278372690@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6419.1278372690@jrobl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 08:31:30AM +0900, J. R. Okajima wrote:
> Recently the size of the pipe buffer becomes customizable, doesn't it?
> For _PC_PIPE_BUF, fpathconf should issue fcntl(F_GETPIPE_SZ).

That should work and is in line with my understanding of the current
code for pathconf in glibc.

> For negative dentry, it should be supported as long as some
> standard/specification doesn't prohibit explicitly. So I still think
> statfs is the best place to implement _PC_LINK_MAX.

If we're going to be changing statfs (or adding a new system call)
anyway, that does seem like a reasonable place to export this data
along with whatever else gets added. With the various things that
have been suggested, maybe we need something more like the stat
replacement that has been getting discussed with the room for some
larger optional fields and a way to request a specific set of fields.

	Brad Boyer
	flar@allandria.com

