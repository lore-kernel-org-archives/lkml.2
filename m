Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1J0Hvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:51:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:39618 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab1J0Hvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:51:50 -0400
Subject: Re: drivers/net/ethernet/apple
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAMuHMdXxqKoPNNo9a+VK-Yzu0Qp-8zY2+OhHL6pDPF=dsnNK5Q@mail.gmail.com>
References: <CAMuHMdXxqKoPNNo9a+VK-Yzu0Qp-8zY2+OhHL6pDPF=dsnNK5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 09:46:39 +0200
Message-ID: <1319701599.30202.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 22:19 +0200, Geert Uytterhoeven wrote:
> Hi Jeff,
> 
> drivers/net/ethernet/apple/mac89x0.c is a driver for the Crystal Semiconductor
> (Now Cirrus Logic) CS89[02]0, so it belongs in drivers/net/ethernet/cirrus,
> next to cs89x0.c.
> 
> And according to drivers/net/ethernet/apple/mace.h, "mace" is the
> "Am79C940 MACE (Medium Access Control for Ethernet)", so mace and
> macmace should be in drivers/net/ethernet/amd/.

The later is hard to tell for sure, it's coupled with an Apple DBDMA
chip and wired in odd ways, so ...

Ben.

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


