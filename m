Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2JVNDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:03:21 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:57184 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753544Ab2JVNDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:03:04 -0400
Message-ID: <1350910971.28457.3.camel@thor>
Subject: Re: [PATCH 1/2] staging: android: checkpatch.pl fixes
From: Peter Hurley <peter@hurleysoftware.com>
To: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>, "Ken O'Brien" <kernel@kenobrien.org>,
        gregkh@linuxfoundation.org, swetland@google.com, arve@android.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Oct 2012 09:02:51 -0400
In-Reply-To: <1350908109.5931.28.camel@joe-AO722>
References: <1350781512.16706.3.camel@joe-AO722>
	 <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
	 <18159.1350898659@warthog.procyon.org.uk>
	 <1350908109.5931.28.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 05:15 -0700, Joe Perches wrote:
> waOn Mon, 2012-10-22 at 10:37 +0100, David Howells wrote:
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > On Sat, 2012-10-20 at 23:33 +0100, Ken O'Brien wrote:
> > > ...
> > > > -		pr_err("binder: %d: binder_alloc_buf failed to "
> > > > +		pr_err("binder: %d: binder_alloc_buf failed to " \
> > > >  		       "map pages in userspace, no vma\n", proc->pid);
> > > ...
> > > Nice try, but the "right" way to do this is to coalesce formats like:
> > > 
> > > 		pr_err("binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> > > 		       proc->pid);
> > 
> > Surely the right way is to fix _checkpatch_ to see ["]\n\s*["] and merge the
> > lines before checking them?  We shouldn't have to fix up the source in either
> > of these fashions just because checkpatch is broken.
> 
> checkpatch is stupid, but it's not broken here.
> 
> Formats should be coalesced into a single line to make
> grepping the source for dmesg output easier.

But MODULE_PARM_DESC() multi-line strings are ok, right?

  grep - 'MODULE_PARM_DESC.*"$' drivers

shows it's in widespread use.

> More likely checkpatch could be changed to bleat yet
> another warning like
> 
> "line continuation used outside macro definition"


