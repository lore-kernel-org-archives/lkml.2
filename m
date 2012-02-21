Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2BUVPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:15:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45906 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab2BUVPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:15:06 -0500
Message-ID: <4F440945.1020904@zytor.com>
Date: Tue, 21 Feb 2012 13:14:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Josh Boyer <jwboyer@gmail.com>, Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com> <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com> <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com>
In-Reply-To: <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 10:26 AM, Linus Torvalds wrote:
> 
> Yes, but I'll send you this with a proper commit log. I'll also send
> you another patch that splits "<asm/i387.h>" into two.
> 
> Right now <asm/i387.h> has two different users: the first of which
> "normal kernel use" kind of things (ie kernel_fpu_begin() and friends)
> that really don't care about the internals very deeply. But the second
> class of user is the actual i387 internal implementation thing that is
> used by i387.c and xsave.c etc to actually implement the exposed
> interfaces.
> 
> As a result, <asm/i387.h> is this mixture of exposed interfaces and
> "deep internal knowledge". And as a result, that deep internal
> knowledge kind of accidentally gets exposed to code that really
> shouldn't be exposed to it.
> 
> I have a patch that fixes that. I'll send you a series of two patches
> with sign-offs and commentary asap.
> 

Thanks!

	-hpa

