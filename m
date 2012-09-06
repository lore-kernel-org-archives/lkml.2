Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563Ab2IFDDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:03:20 -0400
Received: from ozlabs.org ([203.10.76.45]:44441 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2IFDAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:00:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] module: allow loading module from fd
In-Reply-To: <1346275747-8936-1-git-send-email-keescook@chromium.org>
References: <1346275747-8936-1-git-send-email-keescook@chromium.org>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 10:44:08 +0930
Message-ID: <87y5kohs0v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> This changes the init_module syscall so that when the first argument
> (blob address) is NULL, the second argument is used as a file descriptor
> to the module (instead of length). The third argument (module arguments)
> remains unchanged.

Do you know why Linus hates ioctls?  It's because they encourage
casual introduction of new ABIs.

I see you managed the same feat with a different system call.  It avoids
the agony of debate a new system call would entail.  Very clever.

Now do it properly.
Rusty.
