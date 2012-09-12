Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab2ILOiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:38:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41096 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845Ab2ILOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:38:20 -0400
MIME-Version: 1.0
In-Reply-To: <878vcfu22s.fsf@rustcorp.com.au>
References: <1346955201-8926-1-git-send-email-keescook@chromium.org>
	<50500C5C.8060006@zytor.com>
	<878vcfu22s.fsf@rustcorp.com.au>
Date: Wed, 12 Sep 2012 07:38:19 -0700
X-Google-Sender-Auth: zgo-Qand61sEPX1H2wnHz1cdc0A
Message-ID: <CAGXu5jKV4jmsXqv=YhzL-8LAWNs76HNeMu93qLY6AmaeXv8f5g@mail.gmail.com>
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
From: Kees Cook <keescook@chromium.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 12:34 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>
>> On 09/06/2012 11:13 AM, Kees Cook wrote:
>>> Instead of (or in addition to) kernel module signing, being able to reason
>>> about the origin of a kernel module would be valuable in situations
>>> where an OS already trusts a specific file system, file, etc, due to
>>> things like security labels or an existing root of trust to a partition
>>> through things like dm-verity.
>>>
>>> This introduces a new syscall (currently only on x86), similar to
>>> init_module, that has only two arguments. The first argument is used as
>>> a file descriptor to the module and the second argument is a pointer to
>>> the NULL terminated string of module arguments.
>>>
>>
>> Please use the standard naming convention, which is an f- prefix (i.e.
>> finit_module()).
>
> Good point; I just did a replace here.

Ah, yes. Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
