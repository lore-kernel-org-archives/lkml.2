Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab2FETha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:37:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53050 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2FETh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <4FCE38B7.8050106@xenotime.net>
References: <1338839652-29716-1-git-send-email-geert@linux-m68k.org>
	<4FCE38B7.8050106@xenotime.net>
Date: Tue, 5 Jun 2012 21:37:28 +0200
X-Google-Sender-Auth: IS1baogffCm7Y_EG8XaJOVqI25g
Message-ID: <CAMuHMdWbBKk+rnOJDU53tLe5iz8KTM7i-z33EHy6wW9deBAhdQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 6:49 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 06/04/2012 12:54 PM, Geert Uytterhoeven wrote:
>> In addition, I've put the verbose summary at
>> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.5-rc1.summary.gz
>> so you can easily find out for which configs and architectures the
>> errors/warnings you're interested in are happening.
>
> Nope, no such file  :(

Sorry, forgot to remove that chunk. It's still added by my script, while
I haven't studied kup yet...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
