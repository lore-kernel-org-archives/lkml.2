Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab2BUSrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:47:20 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:42833 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab2BUSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:47:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mcgrathr@google.com designates 10.229.114.222 as permitted sender) smtp.mail=mcgrathr@google.com; dkim=pass header.i=mcgrathr@google.com
MIME-Version: 1.0
In-Reply-To: <1329845435-2313-3-git-send-email-wad@chromium.org>
References: <1329845435-2313-1-git-send-email-wad@chromium.org> <1329845435-2313-3-git-send-email-wad@chromium.org>
From: Roland McGrath <mcgrathr@google.com>
Date: Tue, 21 Feb 2012 10:46:53 -0800
Message-ID: <CAB=4xhp6y7Pq7mTF228TdyA-_z2j5z1yEnFrNQrFr7M9BZQ1Fg@mail.gmail.com>
Subject: Re: [PATCH v10 03/11] asm/syscall.h: add syscall_get_arch
To: Will Drewry <wad@chromium.org>
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
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void syscall_get_arch(struct task_struct *task, struct pt_regs *regs);

Bad return type.
