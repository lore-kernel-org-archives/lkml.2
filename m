Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab2JGHn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 03:43:59 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46593 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2JGHn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 03:43:58 -0400
MIME-Version: 1.0
In-Reply-To: <50702DF0.32447.D66E777@pageexec.freemail.hu>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<506D8669.30501.3087FAA@pageexec.freemail.hu>
	<CAKFga-eLC+2utN05Yu_CwEMLsXNi64Fn0zv36O5T=u7ncn+B+Q@mail.gmail.com>
	<50702DF0.32447.D66E777@pageexec.freemail.hu>
Date: Sun, 7 Oct 2012 09:43:58 +0200
Message-ID: <CAKFga-erNuJ8_aLtd1b0JS1YwX1LrsCEJjEeOT67V0AqLHj_SQ@mail.gmail.com>
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
From: Ard Biesheuvel <ard.biesheuvel@gmail.com>
To: pageexec@freemail.hu
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>,
        spender@grsecurity.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/6 PaX Team <pageexec@freemail.hu>:
> sadly, this is not true at all, for multiple reasons:
>
.. snip ...
>
> cheers,
>   PaX Team
>

So can I summarize your position as that there is no merit at all in
the ability to inhibit future permissions of existing mappings?

-- 
Ard.
