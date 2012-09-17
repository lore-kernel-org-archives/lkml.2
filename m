Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2IQRNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:13:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52985 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab2IQRNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:13:43 -0400
MIME-Version: 1.0
In-Reply-To: <50575855.8040308@zytor.com>
References: <504DEA1B020000780009A277@nat28.tlf.novell.com>
 <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org>
 <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com>
 <5056F04B020000780009BAF9@nat28.tlf.novell.com> <20120917100046.GA32463@gmail.com>
 <CA+55aFwKkW7+Xv4-36JsbR7rDyorC8xcTsL_XnYCq=XNTZeJFw@mail.gmail.com> <50575855.8040308@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Sep 2012 10:13:21 -0700
X-Google-Sender-Auth: xFEac_KzOhyn4N9su1z-CzyafsI
Message-ID: <CA+55aFwwQXKxBVL9+izE-utGYKyWy4=6gu0C4b_oC=wFgM+EhA@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86: Prefer TZCNT over BFS
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jan Beulich <JBeulich@suse.com>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 10:05 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Honestly, I don't see a reason to not do this unconditionally.

Possibly. "unconditional" is certainly a lot saner than "conditionally
on totally insane things".

                 Linus
