Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2LUDjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 22:39:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab2LUDjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 22:39:10 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAGXu5jJtoPdhZ_DGeaCT1AsUuLfS4LThaR0PkKbwmTG2rDPZKw@mail.gmail.com>
References: <20121221030018.GA15032@www.outflux.net> <CAGXu5jJtoPdhZ_DGeaCT1AsUuLfS4LThaR0PkKbwmTG2rDPZKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] stack and heap are executable on x86_64
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 20 Dec 2012 19:30:07 -0800
To: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Message-ID: <2069d03f-0dea-4432-b9aa-5095bafd07d6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wtf...

Kees Cook <keescook@chromium.org> wrote:

>On Thu, Dec 20, 2012 at 7:00 PM, Kees Cook <keescook@chromium.org>
>wrote:
>> While trying to fix test_nx, I discovered that it looks like stack
>and
>> heap are executable again (at least on x86_64). :( I tried to bisect
>
>Btw, this ends up looking like this on v3.4:
>
>[    2.486223] test_nx: Testing NX protection ...
>[    2.487468] test_nx: calling ffff88001dd57e45 (0xC3)
>[    2.488766] test_nx: stack is executable
>[    2.489802] test_nx: calling ffff88001e2c7580 (0xC3)
>[    2.491106] test_nx: heap is executable
>[    2.492086] test_nx: calling ffffffff81803c80 (0xC3)
>[    2.493201] test_nx: calling ffffffffa0002220 (0xC3)
>[    2.493843] test_nx: calling ffffffffa0001224 (0xC3)
>[    2.494549] test_nx: Done testing.
>
>-Kees
>
>--
>Kees Cook
>Chrome OS Security

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
