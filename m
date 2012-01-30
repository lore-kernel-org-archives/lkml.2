Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2A3WaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:30:18 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61774 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2A3WaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:30:16 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
 <1327706681-11959-2-git-send-email-wad@chromium.org> <c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
 <CABqD9hatfCSSqUt-FYUa6-LcCeDEht8gLMAY7cnWKe6gp-9upg@mail.gmail.com>
 <13b3f9dcf188908604a9529ef1934ecf.squirrel@webmail.greenhost.nl> <CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 30 Jan 2012 14:29:54 -0800
X-Google-Sender-Auth: umgFJEb6Gn5vgI2jl9eh7Qfjvmc
Message-ID: <CAObL_7F-vXXbkj8-9xsrxETyUka5xQ0jD9teN_Li50QzRYZugw@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
To: Will Drewry <wad@chromium.org>
Cc: Indan Zupancic <indan@nul.nu>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, mcgrathr@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[not quoting anything because this is a more general question]

How portable across architectures is this supposed to be?  At least
syscall numbering varies widely, and calling conventions can be
different (x86_64 has four of them, for example).  For all I know,
argument order might be different in some cases.

--Andy
