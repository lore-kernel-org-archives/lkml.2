Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab2AKUKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:10:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37457 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2AKUKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:10:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120111130349.0dda72b3@dt>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-3-git-send-email-wad@chromium.org>
	<20120111130349.0dda72b3@dt>
Date: Wed, 11 Jan 2012 14:10:19 -0600
Message-ID: <CABqD9hbQRinbYqqwjqH8TfDvkOpESwiCp1uEE8d0Q7Rp4tsM0A@mail.gmail.com>
Subject: Re: [RFC,PATCH 2/2] Documentation: prctl/seccomp_filter
From: Will Drewry <wad@chromium.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 2:03 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> Interesting approach to the problem, I think I like it.  Watch for news at
> 11...:)

Thanks - I'm glad to hear it!

> One nit:
>
>> +Example
>> +-------
>> +
>> +Assume a process would like to cleanly read and write to stdin/out/err and exit
>> +cleanly.  Without using a BPF compiler, it may be done as follows on x86 32-bit:
>> +
>
> It seems like this little program belongs in the samples/ directory.

Cool - I'll do that and rev this patch.

cheers!
will
