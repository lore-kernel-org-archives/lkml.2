Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2JVUAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:00:52 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:56786 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2JVUAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:00:51 -0400
Date: Mon, 22 Oct 2012 13:00:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: xiaobing.tu@intel.com, ccross@android.com, davej@redhat.com,
        akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, di.zhang@intel.com, xindong.ma@intel.com,
        alex.zuo@intel.com
Subject: Re: [PATCH 1/2] Staging: android: binder: Fix memory leak on
 thread/process exit
Message-ID: <20121022200047.GA18175@kroah.com>
References: <20121015235836.GA3214@kroah.com>
 <1350347562-32643-1-git-send-email-arve@android.com>
 <20121016071136.GB5172@kroah.com>
 <CAMP5XgfVPeN8CRwKxeTv6fL8M0MXV56R+GrWw88caVZrQfu+Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP5XgfVPeN8CRwKxeTv6fL8M0MXV56R+GrWw88caVZrQfu+Vg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 03:45:20PM -0700, Arve Hjønnevåg wrote:
> On Tue, Oct 16, 2012 at 12:11 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Oct 15, 2012 at 05:32:41PM -0700, Arve Hjønnevåg wrote:
> >> If a thread or process exited while a reply, one-way transaction or
> >> death notification was pending, the struct holding the pending work
> >> was leaked.
> >>
> >> Change-Id: I2eaafaba1c0ecda3ec0872d449dc16d0721c21e7
> >
> > What is this field?  Please don't include this in kernel patches, it
> > forces me to edit the patch by hand :(
> >
> 
> It is a tag generated a git hook to uniquely identify a change through
> multiple revisions of that change. If the tag does not already exist
> the hook adds it. I removed it from the reposted patches as you
> requested, but have you considered leaving it in? It is a useful
> search token both for finding different revisions of a patch and for
> finding which branch a change has been cherry-picked into.

Sorry, I was being facetious, I knew what it really was, but the point
was, why would I?

As has been stated before, you can include information like this in your
patch, but you MUST reference it properly so that others can be able to
figure out what you mean.  A random Change-Id value means nothing given
that lots of different groups use gerrit.  You need a url, or a pointer
to which gerrit instance this refers to before you can include it.

Same goes for bugzilla entries, if you look in the kernel changelog, we
reference lots of different ones, but we use urls to determine which one
we are talking about (suse, red hat, kernel.org, etc.)

thanks,

greg k-h
