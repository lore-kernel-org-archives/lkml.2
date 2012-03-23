Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab2CWK24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 06:28:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60001 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab2CWK2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:28:54 -0400
MIME-Version: 1.0
In-Reply-To: <E1SAzcK-0001aj-CS.shc_work-mail-ru@f287.mail.ru>
References: <1332487384-13803-1-git-send-email-shc_work@mail.ru>
	<CAMuHMdXoJhWVoRrhgYzVcv3tbThzmtiZ4ZY6pjUM2eji5XuK2A@mail.gmail.com>
	<E1SAzcK-0001aj-CS.shc_work-mail-ru@f287.mail.ru>
Date: Fri, 23 Mar 2012 11:28:53 +0100
X-Google-Sender-Auth: 3wMRIj3AhPiaZy3Ew0OC64kU5Og
Message-ID: <CAMuHMdXjs=Vg2V1zLKYKUYntCESKejSq45D09eXH1zBw2dpMfQ@mail.gmail.com>
Subject: Re: Re[2]: [PATCH] Fix build error with !SMP && !GENERIC_HARDIRQS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 09:13, Alexander Shiyan <shc_work@mail.ru> wrote:
> Fri, 23 Mar 2012 08:46:15 +0100 от Geert Uytterhoeven <geert@linux-m68k.org>:
>> On Fri, Mar 23, 2012 at 08:23, Alexander Shiyan <shc_work@mail.ru> wrote:
>> > When compile kernel with !SMP && !GENERIC_HARDIRQS we are have
>> > following error:
>> Is this on uniprocessor s390?
> No. I trying to fix other problem with ARM Cirrus Logic EP7312 that do not work since 2.6.30-rc1.

Then it should not happen, as s390 is the sole remaining arch that doesn't use
generic hardirqs.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
