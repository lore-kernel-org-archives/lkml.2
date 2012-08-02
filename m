Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2HBAw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 20:52:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49207 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab2HBAwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 20:52:55 -0400
References: <1343859049-3632-1-git-send-email-meredydd@senatehouse.org> <5019B36A.4030604@zytor.com> <CAD=T17Esguer01OsrxMtqEcHKZ-Ovg05+MxSdF7NhXENsUubgg@mail.gmail.com> <5019BC0E.4010109@zytor.com> <5019BCA7.7060106@zytor.com> <CAD=T17GaEMU_PDDvaJ9GVRUtzTZ069AN2yTuX6=rVo6jNO+6oA@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAD=T17GaEMU_PDDvaJ9GVRUtzTZ069AN2yTuX6=rVo6jNO+6oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [RFC] syscalls,x86: Add execveat() system call (v2)
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 01 Aug 2012 17:52:29 -0700
To: Meredydd Luff <meredydd@senatehouse.org>
CC: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Jeff Dike <jdike@addtoit.com>
Message-ID: <ca88add3-881a-4d0c-afc1-b255d60d2163@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry misunderstood your offlist mail   I can cook up an x32 binary easily enough.

Meredydd Luff <meredydd@senatehouse.org> wrote:

>On 2 Aug 2012 00:33, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> > Sorry, you're right.  The argument vector needs compatibility
>support.
>> >
>> > This means you need an x32 version of the function
>
>This is why I originally asked you (off-list) whether it was okay to
>omit
>x32 support in the initial patch :)
>
>I have x32 code already, but I don't have the toolchain or glibc to
>test
>it. (Nor the pain tolerance to build the bleeding-edge versions on this
>laptop - unless I really, really need to...)
>
>If you (or someone else with a working x32 toolchain) could build a
>static
>binary from a tiny test program, I could test that code and put it back
>in
>the patch.
>
>Meredydd

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
