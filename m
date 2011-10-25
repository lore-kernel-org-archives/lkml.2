Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1JYSfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:35:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48020 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1JYSfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:35:53 -0400
MIME-Version: 1.0
In-Reply-To: <4ea6fbe8.43310e0a.592c.5416SMTPIN_ADDED@mx.google.com>
References: <4ea6fbe8.43310e0a.592c.5416SMTPIN_ADDED@mx.google.com>
Date: Tue, 25 Oct 2011 20:35:52 +0200
X-Google-Sender-Auth: ss9mbG-1ke1IIj4ACk3I-IbBm9k
Message-ID: <CAMuHMdWVdaq+uuCLxuN0EsmJiQdyr9xWpqg6oAeHg3NP_u2V8g@mail.gmail.com>
Subject: Re: [PATCH 6/8] clocksource: m86knommu: Convert to clocksource_register_hz/khz
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: y@kernel.beaverton.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Greg Ungerer <gerg@uclinux.org>, Greg Ungerer <gerg@snapgear.com>,
        uClinux development list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 20:08,  <y@kernel.beaverton.ibm.com> wrote:
> From: John Stultz <johnstul@us.ibm.com>
>
> This converts the m86knommu clocksources to use clocksource_register_hz/khz
>
> This is untested, so any assistance in testing would be appreciated!
>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Greg Ungerer <gerg@uclinux.org>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> ---
>  arch/m68k/platform/68328/timers.c         |    4 +-
>  arch/m68k/platform/coldfire/dma_timer.c   |    5 +-
>  arch/m68knommu/platform/coldfire/pit.c    |  167 ++++++++++++++++++++++++++++
>  arch/m68knommu/platform/coldfire/timers.c |  172 +++++++++++++++++++++++++++++
>  4 files changed, 341 insertions(+), 7 deletions(-)
>  create mode 100644 arch/m68knommu/platform/coldfire/pit.c
>  create mode 100644 arch/m68knommu/platform/coldfire/timers.c

arch/m68knommu no longer exists.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
