Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2FJJZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 05:25:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61361 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2FJJZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 05:25:36 -0400
MIME-Version: 1.0
In-Reply-To: <1339320244-22792-1-git-send-email-geert@linux-m68k.org>
References: <1339320244-22792-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 10 Jun 2012 11:25:35 +0200
X-Google-Sender-Auth: cSvXmBPuXklDh211pilbXv6U1Mk
Message-ID: <CAMuHMdVZd_HvT=7MdhZ2jkLz0DYzzAH3aUASAZv4RaB3pfuq+w@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 11:24 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.5-rc2 to v3.5-rc1[3], the summaries are:
>  - build errors: +34/-11

Nothing serious here: some xtensa and avr32 allnoconfig issues, and
the recurring
powerpc randconfig issues.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
