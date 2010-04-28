Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0D1OmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:42:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989Ab0D1OmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:42:12 -0400
Date: Wed, 28 Apr 2010 07:39:12 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trond.myklebust@fys.uio.no, linux-nfs@vger.kernel.org,
       Trond.Myklebust@netapp.com, cel@citi.umich.edu, davem@davemloft.net,
       tmtalpey@gmail.com
Subject: Re: [patch 1/1] sunrpc: use formatting of module name in SUNRPC
Message-Id: <20100428073912.f15206fa.akpm@linux-foundation.org>
In-Reply-To: <l2l81b0412b1004280040t415657c7qe7de59f152cd49aa@mail.gmail.com>
References: <201004272115.o3RLFnKj020353@imap1.linux-foundation.org>
	<l2l81b0412b1004280040t415657c7qe7de59f152cd49aa@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 09:40:36 +0200 Alex Riesen <raa.lkml@gmail.com> wrote:

> On Tue, Apr 27, 2010 at 23:15,  <akpm@linux-foundation.org> wrote:
> > From: Alex Riesen <raa.lkml@gmail.com>
> >
> > gcc-4.3.3 produces the warning:
> > __"format not a string literal and no format arguments"
> >
> > Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
> > Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Cc: Chuck Lever <cel@citi.umich.edu>
> > Cc: David S. Miller <davem@davemloft.net>
> > Acked-by: Tom Talpey <tmtalpey@gmail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> > __net/sunrpc/xprt.c | __ __5 +----
> > __1 file changed, 1 insertion(+), 4 deletions(-)
> >
> 
> This is one tough little patch... 2 years and counting...

heh.  I've only had it since June '09.

I'll merge it into 2.6.35-rc1.
