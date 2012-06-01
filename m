Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722Ab2FANJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:09:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33728 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab2FANJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1206011559370.10517@math.ut.ee>
References: <alpine.SOC.1.00.1206011559370.10517@math.ut.ee>
Date: Fri, 1 Jun 2012 15:09:19 +0200
X-Google-Sender-Auth: rgwsugLVPEAEfx64T0p2N7fJrWo
Message-ID: <CAMuHMdXtZg7JJ18Ao+yLJ5s-vHt38Omgp=b4vOOFet870Buuzw@mail.gmail.com>
Subject: Re: f71805f arch dependencies?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 3:01 PM, Meelis Roos <mroos@linux.ee> wrote:
> Loading f71805f on sparc64 causes hard reboot beacuse on invalid
> hardware access. Should this driver be restricted to PC, or some wider
> subset of platforms where this LPC SUper-IO chip is present?

Which tree is f71805f in? Not in Linus'.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
