Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2ASUR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:17:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37451 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab2ASURy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:17:54 -0500
MIME-Version: 1.0
In-Reply-To: <4F187980.2000306@zytor.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
 <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com> <4F187980.2000306@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Jan 2012 12:17:32 -0800
X-Google-Sender-Auth: 0UQ18y-rdxiRTXAIvf6wL3Mx3-o
Message-ID: <CA+55aFxNVaJ8AYXka8khUnkzr=tND9+SMpQ9CU0KFDbvxAJY0Q@mail.gmail.com>
Subject: Re: dmsetup fails on latest kernel
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 12:13 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Could you please send me:
>
> a) your full strace;
> b) arch/x86/kernel/syscall_32.o from your build?

Btw, the strace before-and-after (working vs nonworking) would
probably be useful. They aren't easily comparable (all the random
pointers change depending on allocations etc), but some scripting and
editing out pointer values might make the difference be obvious.

                         Linus
