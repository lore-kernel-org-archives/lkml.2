Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758Ab2ILDEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 23:04:21 -0400
Received: from tundra.namei.org ([65.99.196.166]:40925 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327Ab2ILDET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 23:04:19 -0400
Date: Wed, 12 Sep 2012 12:57:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
In-Reply-To: <87d31ufy47.fsf@rustcorp.com.au>
Message-ID: <alpine.LRH.2.02.1209121256380.4482@tundra.namei.org>
References: <1346955201-8926-1-git-send-email-keescook@chromium.org> <87ipbqhenn.fsf@rustcorp.com.au> <1347037964.31197.100.camel@falcor> <CAGXu5jKvg9Dhu-PLCZkPazSTFSngg5nzU6Ss4CZ2qaHZ7rugXA@mail.gmail.com> <87d31ufy47.fsf@rustcorp.com.au>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012, Rusty Russell wrote:

> Kees Cook <keescook@chromium.org> writes:
> > On Fri, Sep 7, 2012 at 10:12 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >> This method is a consistent and extensible approach to verifying the
> >> integrity of file data/metadata, including kernel modules. The only
> >> downside to this approach, I think, is that it requires changes to the
> >> userspace tool.
> >
> > I'm fine with this -- it's an expected change that I'll pursue with
> > glibc, kmod, etc. Without the userspace changes, nothing will use the
> > new syscall. :) I've already got kmod (and older module-init-tools)
> > patched to do this locally.
> 
> A syscall is the right way to do this.  But does it need to be done?
> 
> 1) Do the LSM guys really want this hook?

Yes.

Acked-by: James Morris <james.l.morris@oracle.com>



