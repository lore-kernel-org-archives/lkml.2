Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab2BUS5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:57:06 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46444 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755648Ab2BUS5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:57:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=4xhp6y7Pq7mTF228TdyA-_z2j5z1yEnFrNQrFr7M9BZQ1Fg@mail.gmail.com>
References: <1329845435-2313-1-git-send-email-wad@chromium.org>
	<1329845435-2313-3-git-send-email-wad@chromium.org>
	<CAB=4xhp6y7Pq7mTF228TdyA-_z2j5z1yEnFrNQrFr7M9BZQ1Fg@mail.gmail.com>
Date: Tue, 21 Feb 2012 12:57:01 -0600
Message-ID: <CABqD9hZMbAugb7kAb8W5+-Y8tfbV8B_EN-fFe5QnTbgenr=Kbw@mail.gmail.com>
Subject: Re: [PATCH v10 03/11] asm/syscall.h: add syscall_get_arch
From: Will Drewry <wad@chromium.org>
To: Roland McGrath <mcgrathr@google.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 12:46 PM, Roland McGrath <mcgrathr@google.com> wrote:
>> +void syscall_get_arch(struct task_struct *task, struct pt_regs *regs);
>
> Bad return type.

Bah! Thanks!
