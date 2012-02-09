Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab2BIJW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:22:27 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:52193 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2BIJWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:22:24 -0500
Date: Thu, 9 Feb 2012 07:52:22 +0000
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parse-events: Allow expressions in __print_symbolic()
 fields
Message-ID: <20120209075222.GA30323@stefanha-thinkpad.localdomain>
References: <1315131959-7452-1-git-send-email-stefanha@linux.vnet.ibm.com>
 <1328751364.2200.124.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328751364.2200.124.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12020909-5024-0000-0000-000001A5ACD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 08:36:04PM -0500, Steven Rostedt wrote:
> On Sun, 2011-09-04 at 11:25 +0100, Stefan Hajnoczi wrote:
> > The __print_symbolic() function takes a sequence of key-value pairs for
> > pretty-printing a constant.  The new kvm:kvm_exit print fmt uses the
> > expression:
> > 
> >   __print_symbolic(..., { 0x040 + 1, "DB excp" }, ...)
> > 
> > Currently only atoms are supported and this print fmt fails to parse.
> > This patch adds support for expressions instead of just atoms so that
> > 0x040 + 1 is parsed successfully.
> 
> Egad! Doing some early spring cleaning of my Inbox I stumbled across
> this patch.
> 
> I'll apply it now, thanks!
> 
> Hey, if you ever send me a patch and after a week I don't reply to it,
> don't be afraid to ping me about it. I sometimes get swarms of email
> that I skim over, and will sometimes miss something like this.

I appreciate it, thanks!  I forgot about this one myself :).

Stefan

