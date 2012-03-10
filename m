Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab2CJSqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 13:46:47 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60296 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2CJSqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 13:46:45 -0500
MIME-Version: 1.0
In-Reply-To: <4F5A4BE7.60308@gmail.com>
References: <4F5A4BE7.60308@gmail.com>
Date: Sat, 10 Mar 2012 19:46:43 +0100
X-Google-Sender-Auth: WAicIZKF1u1FxUxJ0pcGx8LlqgE
Message-ID: <CAMuHMdW3O7yS3qA8Kwsk9gbt0WRtLgF_V5wYx2h2MLkC_Gyq9w@mail.gmail.com>
Subject: Re: Git pull on linux-next tree shows "Performing inexact rename detection"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Prasanna Kumar T S M <prasannatsmkumar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 19:28, Prasanna Kumar T S M
<prasannatsmkumar@gmail.com> wrote:
> Doing "git pull" on linux-next tree always shows "Performing inexact
> rename detection" for a very long time (more than a hour and going). It
> also uses more than 1.5GB of RAM (out of 2GB RAM) in my system. Not able
> to do any thing when this is happening - even maximising a window takes
> 2 minutes once such a situation is reached. I am killing the command
> with a Ctrl + C as I am not able to do any work.
>
> What is the reason for this? What it does internally? Is there any way
> to circumvent this? I don't want to clone linux-next again (that seems
> to be the worst case solution).

Don't use pull, follow the instructions from the FAQ:
http://linux.f-seidel.de/linux-next/pmwiki/pmwiki.php?n=Linux-next.FAQ

I thought to remember the FAQ explicitly mentions not to use pull, but
that doesn't seem to be the case.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
