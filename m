Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2JEHa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:30:59 -0400
Received: from ozlabs.org ([203.10.76.45]:58595 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab2JEHaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:30:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
In-Reply-To: <1349355032.2496.11.camel@falcor>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAGXu5jJ5Ap18DmAR6T5REgxffeKp08vtuxB7CXxQ66ntXsf0HA@mail.gmail.com> <87obki23uv.fsf@rustcorp.com.au> <1349355032.2496.11.camel@falcor>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 05 Oct 2012 13:20:39 +0930
Message-ID: <878vbl1ss0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> Why?  Not only have you had these patches sitting for a while, way
> before you had the kernel module patches, they've been acked/signed off
> by Kees, Serge, Eric, and myself.  All security subtree maintainers.
> The module patches could have easily been built on top of Kees' small
> patches.  I am really disappointed!

Me too.

Linus' merge window opened on Monday 1-10-2012.  One week before that
was Monday 24-09-2012, which is the nominal close of my merge window.

The patches were sent on 21-09 (Friday for you, the weekend my time).

If I had nothing else to do on Monday, I would have applied it, but we
spent the week trying to get the module signing patches into shape :(

If I take them now, they need to go through linux-next.  That won't
happen until Monday.  I want two days in linux-next, so that people who
test linux-next get a chance to find issues, so that's Wednesday before
I send to Linus, which is getting very late into the merge window.

And keep adding two days for every trivial issue which is found :(

It's in my modules-wip branch for 3.8.

Cheers,
Rusty.

