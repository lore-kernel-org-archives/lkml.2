Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2JVMPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:15:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35404 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750828Ab2JVMPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:15:11 -0400
Message-ID: <1350908109.5931.28.camel@joe-AO722>
Subject: Re: [PATCH 1/2] staging: android: checkpatch.pl fixes
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: "Ken O'Brien" <kernel@kenobrien.org>, gregkh@linuxfoundation.org,
        swetland@google.com, arve@android.com, viro@zeniv.linux.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Oct 2012 05:15:09 -0700
In-Reply-To: <18159.1350898659@warthog.procyon.org.uk>
References: <1350781512.16706.3.camel@joe-AO722>
	 <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
	 <18159.1350898659@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

waOn Mon, 2012-10-22 at 10:37 +0100, David Howells wrote:
> Joe Perches <joe@perches.com> wrote:
> 
> > On Sat, 2012-10-20 at 23:33 +0100, Ken O'Brien wrote:
> > ...
> > > -		pr_err("binder: %d: binder_alloc_buf failed to "
> > > +		pr_err("binder: %d: binder_alloc_buf failed to " \
> > >  		       "map pages in userspace, no vma\n", proc->pid);
> > ...
> > Nice try, but the "right" way to do this is to coalesce formats like:
> > 
> > 		pr_err("binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> > 		       proc->pid);
> 
> Surely the right way is to fix _checkpatch_ to see ["]\n\s*["] and merge the
> lines before checking them?  We shouldn't have to fix up the source in either
> of these fashions just because checkpatch is broken.

checkpatch is stupid, but it's not broken here.

Formats should be coalesced into a single line to make
grepping the source for dmesg output easier.

More likely checkpatch could be changed to bleat yet
another warning like

"line continuation used outside macro definition"

