Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab1J0FQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 01:16:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49125 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1J0FQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 01:16:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXxqKoPNNo9a+VK-Yzu0Qp-8zY2+OhHL6pDPF=dsnNK5Q@mail.gmail.com>
References: <CAMuHMdXxqKoPNNo9a+VK-Yzu0Qp-8zY2+OhHL6pDPF=dsnNK5Q@mail.gmail.com>
Date: Thu, 27 Oct 2011 07:16:54 +0200
X-Google-Sender-Auth: HLCxCJG1gd8WVKu9fdeNcBmccU4
Message-ID: <CAMuHMdUW5PjPU7qNOPA16CbxHJs-bL4r+aFcEGV95SDRBotXRg@mail.gmail.com>
Subject: Re: drivers/net/ethernet/apple
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Tue, Oct 25, 2011 at 22:19, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> drivers/net/ethernet/apple/mac89x0.c is a driver for the Crystal Semiconductor
> (Now Cirrus Logic) CS89[02]0, so it belongs in drivers/net/ethernet/cirrus,
> next to cs89x0.c.

And on the first -next run since its inclusion:

| drivers/net/ethernet/apple/mac89x0.c:107:20: error: cs89x0.h: No
such file or directory

it needs the (shared) header file which is in drivers/net/ethernet/cirrus/.

http://kisskb.ellerman.id.au/kisskb/buildresult/4835488/

> And according to drivers/net/ethernet/apple/mace.h, "mace" is the
> "Am79C940 MACE (Medium Access Control for Ethernet)", so mace and
> macmace should be in drivers/net/ethernet/amd/.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
