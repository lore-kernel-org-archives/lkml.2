Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2ARBuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:50:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57474 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2ARBuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:50:18 -0500
Date: Wed, 18 Jan 2012 02:50:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
Message-ID: <20120118015013.GR11715@one.firstfloor.org>
References: <CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com> <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com> <20120116183730.GB21112@redhat.com> <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com> <20120117164523.GA17070@redhat.com> <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com> <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com> <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Our ptrace jailer is checking cs to figure out if a task is a compat task
> or not, if the kernel can change that behind our back it means our jailer

Every user program change it behind your back.

Your ptrace jailer isn't.

> I think this behaviour is so unexpected that it can only cause security
> problems in the long run. Is anyone counting on this? Where is this
> behaviour documented?

Look up far jumps in any x86 manual.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
