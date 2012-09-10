Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2IJCbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 22:31:13 -0400
Received: from ozlabs.org ([203.10.76.45]:56412 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab2IJCaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 22:30:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
In-Reply-To: <CAGXu5jKvg9Dhu-PLCZkPazSTFSngg5nzU6Ss4CZ2qaHZ7rugXA@mail.gmail.com>
References: <1346955201-8926-1-git-send-email-keescook@chromium.org> <87ipbqhenn.fsf@rustcorp.com.au> <1347037964.31197.100.camel@falcor> <CAGXu5jKvg9Dhu-PLCZkPazSTFSngg5nzU6Ss4CZ2qaHZ7rugXA@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 10 Sep 2012 11:16:48 +0930
Message-ID: <87d31ufy47.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> On Fri, Sep 7, 2012 at 10:12 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> This method is a consistent and extensible approach to verifying the
>> integrity of file data/metadata, including kernel modules. The only
>> downside to this approach, I think, is that it requires changes to the
>> userspace tool.
>
> I'm fine with this -- it's an expected change that I'll pursue with
> glibc, kmod, etc. Without the userspace changes, nothing will use the
> new syscall. :) I've already got kmod (and older module-init-tools)
> patched to do this locally.

A syscall is the right way to do this.  But does it need to be done?

1) Do the LSM guys really want this hook?
2) Do we have a userspace which uses it?

If yes to both, and noone comes up with any creative complaints, I will
take the patch.

Cheers,
Rusty.
