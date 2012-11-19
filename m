Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2KSS1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:27:22 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45570 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2KSS1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:27:21 -0500
MIME-Version: 1.0
In-Reply-To: <1353302917-13995-46-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
	<1353302917-13995-46-git-send-email-josh@joshtriplett.org>
Date: Mon, 19 Nov 2012 10:27:20 -0800
X-Google-Sender-Auth: w2Dd4a17iWO4XIgiNUwJFqe6JdI
Message-ID: <CAGXu5jKtW0rwgDs6aSi+Ka48B9xMC2PPia1nr2s44Ln6g1RSUw@mail.gmail.com>
Subject: Re: [PATCH 45/58] x86: Fix prototype for renamed function smp_threshold_interrupt
From: Kees Cook <keescook@chromium.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 9:28 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> Commit 7856f6cce4a8cda8c1f94b99605c07d16b8d8dec renamed
> mce_threshold_interrupt to smp_threshold_interrupt, but did not update
> the prototype in arch/x86/include/asm/traps.h to match.  Update the
> prototype to the new name.
>
> This also eliminates warnings from GCC (-Wmissing-prototypes) and Sparse
> (-Wdecl).
>
> arch/x86/kernel/traps.c:597:29: warning: no previous prototype for ‘smp_threshold_interrupt’ [-Wmissing-prototypes]
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
