Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2ALRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:25:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51966 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2ALRZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:25:25 -0500
MIME-Version: 1.0
In-Reply-To: <4F0EDC5C.3040001@gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-3-git-send-email-wad@chromium.org>
	<4F0EDC5C.3040001@gmail.com>
Date: Thu, 12 Jan 2012 11:25:22 -0600
Message-ID: <CABqD9hZmd9eXavwUDOsfNSH0vWyjqH_g4gX=Vf2jGQdRAY3Udw@mail.gmail.com>
Subject: Re: [RFC,PATCH 2/2] Documentation: prctl/seccomp_filter
From: Will Drewry <wad@chromium.org>
To: =?UTF-8?B?xYF1a2FzeiBTb3dh?= <luksow@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 7:13 AM, Łukasz Sowa <luksow@gmail.com> wrote:
> Hi Will,
>
> That's very different approach to the system call interposition problem.
> I find you solution very interesting. It gives far more capabilities
> than my syscalls cgroup that you commented on some time ago. It's ready
> now but I haven't tried filtering yet. I think that if your solution
> make it to the mainline (and I guess that's really possible at current
> stage :)), there will be no place for mine solution but that's ok.

Yeah - there've been so many tries, I'll be happy when one makes it in
which is usable :)

> There's one thing that I'm curious about - have you measured overhead in
> any way? That was one of the biggest issues in all previous attempts to
> limit syscalls. I'd love to compare the numbers with mine solution.

Certainly. I have some rough numbers, but nothing I'd call strong
measurements.  There is still a fair amount of cost due to the syscall
slow path.

> I'll examine your patch later on and put some comments if I bump into
> something.

Much appreciated - cheers!
will
