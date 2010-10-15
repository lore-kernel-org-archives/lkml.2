Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0JOInO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:43:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48435 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0JOInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:43:13 -0400
Date: Fri, 15 Oct 2010 10:43:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        jengelh@medozas.de, davem@davemloft.net, andi@firstfloor.org
Subject: Re: [PATCH] types.h: define __aligned_u64 and expose to userspace
Message-ID: <20101015084311.GA25620@basil.fritz.box>
References: <20101015042455.12772.27482.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015042455.12772.27482.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 12:24:55AM -0400, Eric Paris wrote:
> We currently have a kernel internal type called aligned_u64 which aligns
> __u64's on 8 bytes boundaries even on systems which would normally align
> them on 4 byte boundaries.  This patch creates a new type __aligned_u64
> which does the same thing but which is exposed to userspace rather than
> being kernel internal.
> 
> Based-on-patch-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Andi Kleen <ak@linux.intel.com>

but only if you:

> +/* this is a special 64bit data type that is 8-byte aligned */

Expand this comment a bit that that using this type as a 
replacement for u64 is recommended
for any user visible 64bit value in a structure and that it 
avoids problem with the compat layer on x86-64.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
