Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2KHWjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 17:39:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61719 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab2KHWjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 17:39:04 -0500
MIME-Version: 1.0
In-Reply-To: <509C1A92.9080407@ahsoftware.de>
References: <509C1A92.9080407@ahsoftware.de>
Date: Thu, 8 Nov 2012 14:39:02 -0800
X-Google-Sender-Auth: TorjZ9FeLTk_FzeqLLCqiRO9VL4
Message-ID: <CAE9FiQWeie62NYt2vyq2q+Um8NeA5xWQGy-nULmFidt4XxW=BA@mail.gmail.com>
Subject: Re: [RFC] arm: memtest
From: Yinghai Lu <yinghai@kernel.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 12:48 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> Hello,
>
> I've recently discovered the lack of the command line parameter memtest for
> ARM. So I've made a patch.
>
> But I have some questions:
>
> 1. arch/x86/mm/memtest.c looks platform independ.
> The only thing why I don't use it for arm, is because it uses 64bit
> pointers. Maybe it could be moved to mm/memtest.c. If so, the memtest32.c
> I'm using (basically a copy of memtest.c) could be moved there too.
>
> 2. Because the below memtest32.c is basically a copy of
> arch/x86/mm/memtest.c, I'm not sure if the mapping from physical to virtual
> locations there does fit (always) for ARM too. I know almost as much about
> the in-kernel memory organization on x86 as on ARM, which is not really that
> much (some theory about TLBs, some source code explorations, ..., but I'm
> working on it). ;)

We are using arch/x86/mm/memtest.c for x86 32bit and 64bit.

So it should be ok to use it with arm 32bit and 64bit directly.

Yinghai
