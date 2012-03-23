Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2CWHqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 03:46:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60026 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab2CWHqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 03:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <1332487384-13803-1-git-send-email-shc_work@mail.ru>
References: <1332487384-13803-1-git-send-email-shc_work@mail.ru>
Date: Fri, 23 Mar 2012 08:46:15 +0100
X-Google-Sender-Auth: iAc1BpJMXEMX5vRyW6zVcv1ofvw
Message-ID: <CAMuHMdXoJhWVoRrhgYzVcv3tbThzmtiZ4ZY6pjUM2eji5XuK2A@mail.gmail.com>
Subject: Re: [PATCH] Fix build error with !SMP && !GENERIC_HARDIRQS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 08:23, Alexander Shiyan <shc_work@mail.ru> wrote:
> When compile kernel with !SMP && !GENERIC_HARDIRQS we are have
> following error:

Is this on uniprocessor s390?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
