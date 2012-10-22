Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2JVJhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab2JVJht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:37:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1350781512.16706.3.camel@joe-AO722>
References: <1350781512.16706.3.camel@joe-AO722> <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, "Ken O'Brien" <kernel@kenobrien.org>,
        gregkh@linuxfoundation.org, swetland@google.com, arve@android.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: android: checkpatch.pl fixes
Date: Mon, 22 Oct 2012 10:37:39 +0100
Message-ID: <18159.1350898659@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> On Sat, 2012-10-20 at 23:33 +0100, Ken O'Brien wrote:
> ...
> > -		pr_err("binder: %d: binder_alloc_buf failed to "
> > +		pr_err("binder: %d: binder_alloc_buf failed to " \
> >  		       "map pages in userspace, no vma\n", proc->pid);
> ...
> Nice try, but the "right" way to do this is to coalesce formats like:
> 
> 		pr_err("binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> 		       proc->pid);

Surely the right way is to fix _checkpatch_ to see ["]\n\s*["] and merge the
lines before checking them?  We shouldn't have to fix up the source in either
of these fashions just because checkpatch is broken.

David
