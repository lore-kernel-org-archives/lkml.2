Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2ALRxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:53:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53124 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab2ALRxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:53:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120112171145.31e84b44@pyramind.ukuu.org.uk>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112161806.21a09335@pyramind.ukuu.org.uk>
	<CABqD9hbEzcEF3KbG4=yA2haUUaXB8rMH9JbO+ZkZHU08Nt3ydQ@mail.gmail.com>
	<20120112171145.31e84b44@pyramind.ukuu.org.uk>
Date: Thu, 12 Jan 2012 11:52:59 -0600
Message-ID: <CABqD9hYAnU+3GuXG_G+ywm=vAFgYtE0qHBgHzrNUqR27NgDk=Q@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
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

On Thu, Jan 12, 2012 at 11:11 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> more about).  Since setuid is privilege escalation, then perhaps it
>> makes sense to allow it as an escape hatch.
>>
>> Would it be sane to just disallow setuid exec exclusively?
>
> I think that is a policy question. I can imagine cases where either
> behaviour is the "right" one so it may need to be a parameter ?

Makes sense. I'll make it flaggable (ignoring the parallel conversation
about having a thread-wide suidable bit).

thanks!
