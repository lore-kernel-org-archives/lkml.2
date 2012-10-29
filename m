Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab2J2Pva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:51:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37725 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676Ab2J2Pv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:51:27 -0400
Date: Mon, 29 Oct 2012 08:51:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] percpu: change a method freeing a chunk for consistency.
Message-ID: <20121029155122.GM5171@htj.dyndns.org>
References: <1351519198-5075-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351519198-5075-1-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 10:59:58PM +0900, Joonsoo Kim wrote:
> commit 099a19d9('allow limited allocation before slab is online') changes a method
> allocating a chunk from kzalloc to pcpu_mem_alloc.
> But, it missed changing matched free operation.
> It may not be a problem for now, but fix it for consistency.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>

Applied to percpu/for-3.8 w/ commit message updated.

Thanks.

-- 
tejun
