Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2CBAb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:31:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64739 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2CBAb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:31:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.133.93 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F501282.8050408@teksavvy.com>
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
 <4F4B9FFE.5050709@teksavvy.com> <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com>
 <4F4F8BEE.3040806@teksavvy.com> <CA+55aFyij_ORw+BE-Sbkt9Y9qcUQSmW_4e-r7p3t0DNA4Sg9pA@mail.gmail.com>
 <4F5011AC.2020909@teksavvy.com> <4F501282.8050408@teksavvy.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Mar 2012 16:31:05 -0800
X-Google-Sender-Auth: OjYsHp5_Tt1GWLVp5bC62ApqFJI
Message-ID: <CA+55aFw8GLGtQ+rVi6eqbgyd+qKc3CszMkGv8L+2MC28K61O5Q@mail.gmail.com>
Subject: Re: Linux 3.3-rc5
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 4:21 PM, Mark Lord <kernel@teksavvy.com> wrote:
>
> Here's the promised strace from 64/32 mode:

This is odd.

> ioctl(0x3, 0xc0046986, 0xffc06dcc)      = -1 (errno 22)

When I do a "make drivers/char/i8k.s" (with my patch), I can see that
constant in the resulting code. It's right there. It doesn't return
EINVAL.

Can you send me the patch you are using with the compat_ioctl thing added?

               Linus
