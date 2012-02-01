Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2BARe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:34:59 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33562 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab2BARe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:34:56 -0500
MIME-Version: 1.0
In-Reply-To: <bd6c07e54f2a86916550f69013e4dcc6.squirrel@webmail.greenhost.nl>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
 <1327706681-11959-2-git-send-email-wad@chromium.org> <c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
 <CABqD9hatfCSSqUt-FYUa6-LcCeDEht8gLMAY7cnWKe6gp-9upg@mail.gmail.com>
 <13b3f9dcf188908604a9529ef1934ecf.squirrel@webmail.greenhost.nl>
 <CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
 <8a37c5805a9941a8616f1c28245a0880.squirrel@webmail.greenhost.nl>
 <CABqD9hYpiDtCM5gPgjjHOJ6DcFs-HHUORAGi+AMFs1+9EAk1UA@mail.gmail.com> <bd6c07e54f2a86916550f69013e4dcc6.squirrel@webmail.greenhost.nl>
From: Roland McGrath <mcgrathr@google.com>
Date: Wed, 1 Feb 2012 09:34:31 -0800
Message-ID: <CAB=4xhr73ON-rmiHXFspLANO0JfNWpc4sduF5-z6UaBODsgF6w@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
To: Indan Zupancic <indan@nul.nu>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 5:36 PM, Indan Zupancic <indan@nul.nu> wrote:
>> ref: http://lkml.indiana.edu/hypermail/linux/kernel/0906.3/00096.html
>
> That's 2009! I wonder why no progress happened since then.

At that time I did most of all the CONFIG_HAVE_ARCH_TRACEHOOK work for ARM.
The ARM kernel maintainers just weren't interested in paying attention, and
I gave up on hounding them.  Since then, only a subset of what I did before
has actually been done and merged.  (e.g. there is now some user_regset
support, but less than what I implemented and posted originally--so for
some ARM variants there is still register information only accessible via
old ptrace calls but not in core dumps and no PTRACE_GETREGSET support.
The really trivial stuff like using tracehook_report_* still hasn't gone
in, though I posted that code back then too.)


Thanks,
Roland
