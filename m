Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0JOJCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:02:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab0JOJCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:02:31 -0400
Date: Fri, 15 Oct 2010 02:03:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        jengelh@medozas.de, davem@davemloft.net
Subject: Re: [PATCH] types.h: define __aligned_u64 and expose to userspace
Message-Id: <20101015020310.5a4eddbd.akpm@linux-foundation.org>
In-Reply-To: <20101015084311.GA25620@basil.fritz.box>
References: <20101015042455.12772.27482.stgit@paris.rdu.redhat.com>
	<20101015084311.GA25620@basil.fritz.box>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 10:43:11 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> On Fri, Oct 15, 2010 at 12:24:55AM -0400, Eric Paris wrote:
> > We currently have a kernel internal type called aligned_u64 which aligns
> > __u64's on 8 bytes boundaries even on systems which would normally align
> > them on 4 byte boundaries.  This patch creates a new type __aligned_u64
> > which does the same thing but which is exposed to userspace rather than
> > being kernel internal.
> > 
> > Based-on-patch-by: Andreas Gruenbacher <agruen@suse.de>
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> Acked-by: Andi Kleen <ak@linux.intel.com>
> 
> but only if you:
> 
> > +/* this is a special 64bit data type that is 8-byte aligned */
> 
> Expand this comment a bit that that using this type as a 
> replacement for u64 is recommended
> for any user visible 64bit value in a structure and that it 
> avoids problem with the compat layer on x86-64.
> 

Well yes, I was actually about to write that comment.  But it should
describe the compat problems fully?
