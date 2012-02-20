Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2BTBG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:06:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32970 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2BTBGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:06:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.97.196 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFwHGUB7R6kpNPc7vDYF8dhYCKm4Riso-rpS2Fiqjg8hQg@mail.gmail.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <12996.1329699216@neuling.org> <CA+55aFwHGUB7R6kpNPc7vDYF8dhYCKm4Riso-rpS2Fiqjg8hQg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Feb 2012 17:06:33 -0800
X-Google-Sender-Auth: K1kwThjtCJ73uodRtykhggV7Abk
Message-ID: <CA+55aFxqK1A0g6qHvZHxzGOTGT0YFAoRJtOeYWLxVchM=e=qww@mail.gmail.com>
Subject: Re: [PATCH 0/2] More i387 state save/restore work
To: Michael Neuling <mikey@neuling.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, anton@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 5:03 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> You may have to do something else than just do some FP calculation to
> force it to use VSX on PPC, obviously.

And don't tell me that I should use pipes to bounce a byte back and
forth instead of just relying on sched_yield() hopefully doing what I
wanted it to do even for non-RT case. Yeah, I probably should, but
this was simpler and I'm a moron.

                 Linus
