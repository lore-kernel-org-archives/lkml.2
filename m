Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2AUALE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 19:11:04 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47482 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab2AUALB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 19:11:01 -0500
MIME-Version: 1.0
In-Reply-To: <201201210107.37250.vda.linux@googlemail.com>
References: <20120116183730.GB21112@redhat.com> <4F19EDAF.2000109@zytor.com>
 <d8be1991e82ec686433c5c6e255c2bd9.squirrel@webmail.greenhost.nl> <201201210107.37250.vda.linux@googlemail.com>
From: Roland McGrath <mcgrathr@google.com>
Date: Fri, 20 Jan 2012 16:10:34 -0800
Message-ID: <CAB=4xhpKM5VwhKeoevzp+4VqvstV8siqjy68TJYBBir9F8hP1g@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Indan Zupancic <indan@nul.nu>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 4:07 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
>> Maybe a bit telling whether it is syscall entry or exit?
>
> Yes, this one too. This is one of longstanding annoyances
> that this information is not exposed.

That is not really "state", it's just which event you want.
That is much better addressed by replacing PTRACE_SYSCALL
with PTRACE_O_TRACE_SYSCALL_{ENTRY,EXIT} and PTRACE_EVENT_SYSCALL_{ENTRY,EXIT}.
Oleg can whip that up for you no problem.


Thanks,
Roland
