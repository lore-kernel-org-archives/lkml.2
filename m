Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2DADMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 23:12:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55158 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab2DADMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 23:12:21 -0400
MIME-Version: 1.0
In-Reply-To: <4F77B374.8020203@shealevy.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
 <4F77B374.8020203@shealevy.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 31 Mar 2012 20:11:59 -0700
X-Google-Sender-Auth: pMZRqnujmpFqRqukV9j6yWJiRg8
Message-ID: <CA+55aFx42Vh5hY3fjhupOHjw=WjGgm=4FckXPjQhESS5TZCcjA@mail.gmail.com>
Subject: Re: Linux 3.4-rc1
To: Shea Levy <shea@shealevy.com>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 6:46 PM, Shea Levy <shea@shealevy.com> wrote:
>
> Kernel: arch/x86/boot/bzImage is ready  (#1)
> ERROR: "snd_tea575x_init" [drivers/media/radio/radio-maxiradio.ko] undefined!
> ERROR: "snd_tea575x_exit" [drivers/media/radio/radio-maxiradio.ko] undefined!

Looks like a kconfig file error - RADIO_MAXIRADIO should apparently
depend on SND_TEA575X.

Hans? Mauro?

                     Linus
