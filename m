Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab2EUSrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:47:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37442 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758784Ab2EUSrS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:47:18 -0400
MIME-Version: 1.0
In-Reply-To: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
Date: Mon, 21 May 2012 20:47:16 +0200
Message-ID: <CAFLxGvxtK7Dqw_PDqkMjNYzWyYdqx5CRYLB4+o=S5zHy2CgiTQ@mail.gmail.com>
Subject: Re: seccomp and ptrace. what is the correct order?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Eric Paris <netdev@parisplace.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, hpa@zytor.com, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 8:21 PM, Eric Paris <netdev@parisplace.org> wrote:
> Is that what we want?  Do we want to do the permission check based on
> what a process ask at syscall enter or do we want to do the permission
> check based on what the kernel is actually going to do on behalf of
> the process?

I think we want the latter.
A system call emulator like UserModeLinux would benefit from that.

-- 
Thanks,
//richard
