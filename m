Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031410Ab2CPVcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:32:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64538 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab2CPVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:32:31 -0400
Date: Fri, 16 Mar 2012 14:32:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] staging: zsmalloc: add user-definable alloc/free funcs
Message-ID: <20120316213227.GB24556@kroah.com>
References: <1331931888-14175-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331931888-14175-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 04:04:48PM -0500, Seth Jennings wrote:
> This patch allows a zsmalloc user to define the page
> allocation and free functions to be used when growing
> or releasing parts of the memory pool.
> 
> The functions are passed in the struct zs_pool_ops parameter
> of zs_create_pool() at pool creation time.  If this parameter
> is NULL, zsmalloc uses alloc_page and __free_page() by default.
> 
> While there is no current user of this functionality, zcache
> development plans to make use of it in the near future.

I'm starting to get tired of seeing new features be added to this chunk
of code, and the other related bits, without any noticable movement
toward getting it merged into the mainline tree.

So, I'm going to take a stance here and say, no more new features until
it gets merged into the "real" part of the kernel tree, as you all
should not be spinning your wheels on new stuff, when there's no
guarantee that the whole thing could just be rejected outright tomorrow.

I'm sorry, I know this isn't fair for your specific patch, but we have
to stop this sometime, and as this patch adds code isn't even used by
anyone, its a good of a time as any.

greg k-h
