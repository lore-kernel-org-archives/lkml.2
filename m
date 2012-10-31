Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab2JaBlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:41:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49938 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2JaBlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:41:12 -0400
Date: Tue, 30 Oct 2012 18:42:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, gaowanlong@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] zram/zsmalloc promotion
Message-ID: <20121031014209.GB2672@kroah.com>
References: <1351501009-15111-1-git-send-email-minchan@kernel.org>
 <20121031010642.GN15767@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031010642.GN15767@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:06:42AM +0900, Minchan Kim wrote:
> Thanks all,
> 
> At last, everybody who contributes to zsmalloc want to put it under /lib.
> 
> Greg,
> What should I do for promoting this dragging patchset?

You need to get the -mm developers to agree that this is something that
is worth accepting.  I have yet to see any compeling argument why this
even needs to be in the kernel in the first place.

I'm not moving this anywhere until you get their acceptance.

greg k-h
