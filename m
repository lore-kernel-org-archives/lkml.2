Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab1HOWcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 18:32:31 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51816 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1HOWc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 18:32:29 -0400
MIME-Version: 1.0
In-Reply-To: <1313447210-9149-1-git-send-email-cesarb@cesarb.net>
References: <1313447210-9149-1-git-send-email-cesarb@cesarb.net>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 15 Aug 2011 18:32:09 -0400
X-Google-Sender-Auth: ITHtwF79YphIot9mj3Pq8hHJOhY
Message-ID: <CAObL_7G8qM_qq0qp-UHuuwyCretqzcVhVw-gc3O9TCQJN8zHkA@mail.gmail.com>
Subject: Re: [PATCH] x86-64: remove int 0xcc from entry_64.S documentation
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 6:26 PM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> Commit 3ae36655b97a03fa1decf72f04078ef945647c1a (x86-64: Rework vsyscall
> emulation and add vsyscall= parameter) removed the special use of the
> 0xcc IDT vector.
>
> Remove it from Documentation/x86/entry_64.txt also.
>
> Cc: Andy Lutomirski <luto@MIT.EDU>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  Documentation/x86/entry_64.txt |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
> index 7869f14..bc7226e 100644
> --- a/Documentation/x86/entry_64.txt
> +++ b/Documentation/x86/entry_64.txt
> @@ -27,9 +27,6 @@ Some of these entries are:
>    magically-generated functions that make their way to do_IRQ with
>    the interrupt number as a parameter.
>
> - - emulate_vsyscall: int 0xcc, a special non-ABI entry used by
> -   vsyscall emulation.
> -
>  - APIC interrupts: Various special-purpose interrupts for things
>    like TLB shootdown.
>

Acked-by: Andy Lutomirski <luto@mit.edu>

--Andy
