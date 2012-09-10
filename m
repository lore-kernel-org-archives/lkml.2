Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2IJPHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:07:09 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48220 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab2IJPHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:07:04 -0400
MIME-Version: 1.0
In-Reply-To: <87d31ufy47.fsf@rustcorp.com.au>
References: <1346955201-8926-1-git-send-email-keescook@chromium.org>
	<87ipbqhenn.fsf@rustcorp.com.au>
	<1347037964.31197.100.camel@falcor>
	<CAGXu5jKvg9Dhu-PLCZkPazSTFSngg5nzU6Ss4CZ2qaHZ7rugXA@mail.gmail.com>
	<87d31ufy47.fsf@rustcorp.com.au>
Date: Mon, 10 Sep 2012 08:07:03 -0700
X-Google-Sender-Auth: 45WApp2Y6WWu5Sp5vlUClCK3YI4
Message-ID: <CAGXu5jK7g2_W_cb8-JQV_f0EdUhbVkcaOR3KECHoC8nnrMzTCw@mail.gmail.com>
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
From: Kees Cook <keescook@chromium.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 6:46 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Kees Cook <keescook@chromium.org> writes:
>> On Fri, Sep 7, 2012 at 10:12 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>>> This method is a consistent and extensible approach to verifying the
>>> integrity of file data/metadata, including kernel modules. The only
>>> downside to this approach, I think, is that it requires changes to the
>>> userspace tool.
>>
>> I'm fine with this -- it's an expected change that I'll pursue with
>> glibc, kmod, etc. Without the userspace changes, nothing will use the
>> new syscall. :) I've already got kmod (and older module-init-tools)
>> patched to do this locally.
>
> A syscall is the right way to do this.  But does it need to be done?
>
> 1) Do the LSM guys really want this hook?

The LSM hook half has already been acked by Serge and Eric, and I want
to use it in Yama as well.

> 2) Do we have a userspace which uses it?

Chrome OS will be using it; I have patches for kmod and
module-init-tools already.

> If yes to both, and noone comes up with any creative complaints, I will
> take the patch.

Sound good; thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
