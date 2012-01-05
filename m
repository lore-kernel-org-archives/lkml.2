Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2AEAqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:46:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab2AEAqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:46:40 -0500
Date: Wed, 4 Jan 2012 16:46:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfs: iversion truncate bug fix
Message-Id: <20120104164638.cc21fc2e.akpm@linux-foundation.org>
In-Reply-To: <1325723630.13419.2.camel@falcor>
References: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
	<1324560391.1964.8.camel@falcor>
	<20120104152801.d8f555ca.akpm@linux-foundation.org>
	<1325723630.13419.2.camel@falcor>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jan 2012 19:33:49 -0500
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> On Wed, 2012-01-04 at 15:28 -0800, Andrew Morton wrote:
> > On Thu, 22 Dec 2011 08:26:30 -0500
> > Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > 
> > > On Thu, 2011-12-22 at 12:54 +0200, Dmitry Kasatkin wrote:
> > > > When a file is truncated with truncate()/ftruncate() and then closed,
> > > > iversion is not updated. This patch uses ATTR_SIZE flag as an indication
> > > > to increment iversion.
> > > > 
> > > > Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> > > 
> > > Acked-by: Mimi Zohar <zohar@us.ibm.com> 
> > > (Stable should be cc'ed on this patch.)
> > 
> > why?
> 
> Why backported?

Yes.  If you want to submit the patch to the -stable maintainer then
you should explain to him why the fix is important enough to warrant
doing that.  That involves explaining the user-visible effects of
the bug.

>  The IMA measurement list could be incomplete.

In more detail than this.  Maybe he knows what the above sentence
means, but I sure don't.
