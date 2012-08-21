Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab2HUSXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:23:01 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43772 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab2HUSW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120821160653.GH12708@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
	<201208151415.39570.arnd@arndb.de>
	<20120816102300.GG31784@mudshark.cambridge.arm.com>
	<201208161237.53594.arnd@arndb.de>
	<20120821160653.GH12708@arm.com>
Date: Tue, 21 Aug 2012 20:17:19 +0200
X-Google-Sender-Auth: zYJtvsFpoFCKTEBX9Br4Do3T7HQ
Message-ID: <CAMuHMdVEX0egzFETMJ=LA_PB+7Qc=Ph-7uxofVr__wOE-0cvLQ@mail.gmail.com>
Subject: Re: [PATCH v2 16/31] arm64: ELF definitions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 6:06 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> But I can see on x86 that it always reports x86_64 even if the task is
> x86_32.

Really?

$ uname -m
x86_64
$ linux32 uname -m
i686
$

On Ubuntu 2.6.32-42-generic

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
