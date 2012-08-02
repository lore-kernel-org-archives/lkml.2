Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2HBKvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:51:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60804 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2HBKvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:51:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120802103001.GJ6481@ZenIV.linux.org.uk>
References: <1343859049-3632-1-git-send-email-meredydd@senatehouse.org>
 <5019B36A.4030604@zytor.com> <CAD=T17Esguer01OsrxMtqEcHKZ-Ovg05+MxSdF7NhXENsUubgg@mail.gmail.com>
 <5019BC0E.4010109@zytor.com> <20120802065557.GI6481@ZenIV.linux.org.uk>
 <CAD=T17Gkryua5TQW5h18kCu+yiViuVv6NyxtMw3C9we0RWzmKQ@mail.gmail.com> <20120802103001.GJ6481@ZenIV.linux.org.uk>
From: Meredydd Luff <meredydd@senatehouse.org>
Date: Thu, 2 Aug 2012 11:51:31 +0100
Message-ID: <CAD=T17E5kYvfW7WPGpj_kPd=TQChnSTCPjn8OWv0X7uXAo8sLg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] syscalls,x86: Add execveat() system call (v2)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 11:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> FWIW, I've just pushed (completely untested) arm and alpha
> parts of what I described into signal.git#execve2; x86 is
> next.  Note that after that sys_execve() is identical on
> converted architectures and can be merged; ditto for
> kernel_execve().  After I do x86 counterpart, I'll
> take those guys to fs/exec.c under ifdef for new __ARCH_HAS_...
> (and define it on already converted ones, obviously).
> Then your patch goes there, except that implementation
> gets put into fs/exec.c, under the same ifdef.  And with
> current_pt_regs() used instead of the extra argument,
> of course.  From that point on it can be used on any converted
> architecture.

OK, that makes sense to me.

What would you need from me, and when? Should I just wait for your
#ifdef-ed sys_execve() in fs/exec.c, and re-spin the patch based on
that?

Is there anything else I can/should do in the meantime to make this
patch acceptable?

Meredydd
