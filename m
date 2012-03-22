Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031008Ab2CVQ5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:57:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34281 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462Ab2CVQ5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:57:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120319163015.GA9988@gmail.com>
References: <20120319163015.GA9988@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Mar 2012 09:57:24 -0700
X-Google-Sender-Auth: 2Htqs6XN1tnnCj5QcS8nX7i8yaY
Message-ID: <CA+55aFzTFa0uxnf7f=kXyJRNE9FGTUtvyfcej1UeMja1-AcZ-A@mail.gmail.com>
Subject: Re: [GIT PULL] x86/build changes for v3.4
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grr.

This causes

  In file included from tools/include/tools/le_byteshift.h:4:0,
                   from arch/x86/boot/tools/build.c:35:
  include/linux/types.h:13:2: warning: #warning "Attempt to use kernel
headers from user space, see http://kernelnewbies.org/KernelHeaders"

for my build. How come nobody noticed?

                 Linus

On Mon, Mar 19, 2012 at 9:30 AM, Ingo Molnar <mingo@kernel.org> wrote:
> Linus,
>
> Please pull the latest x86-build-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus
>
>   HEAD: a51f4047758d2bcd099ea113b833ed380f4024ba x86, build: Fix portability issues when cross-building
