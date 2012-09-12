Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab2ILLQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:16:21 -0400
Received: from ozlabs.org ([203.10.76.45]:41852 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab2ILLQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:16:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
In-Reply-To: <50500C5C.8060006@zytor.com>
References: <1346955201-8926-1-git-send-email-keescook@chromium.org> <50500C5C.8060006@zytor.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 12 Sep 2012 17:04:19 +0930
Message-ID: <878vcfu22s.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 09/06/2012 11:13 AM, Kees Cook wrote:
>> Instead of (or in addition to) kernel module signing, being able to reason
>> about the origin of a kernel module would be valuable in situations
>> where an OS already trusts a specific file system, file, etc, due to
>> things like security labels or an existing root of trust to a partition
>> through things like dm-verity.
>>
>> This introduces a new syscall (currently only on x86), similar to
>> init_module, that has only two arguments. The first argument is used as
>> a file descriptor to the module and the second argument is a pointer to
>> the NULL terminated string of module arguments.
>>
>
> Please use the standard naming convention, which is an f- prefix (i.e. 
> finit_module()).

Good point; I just did a replace here.

Thanks,
Rusty.
