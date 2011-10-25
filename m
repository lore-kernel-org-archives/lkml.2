Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1JYUTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:19:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48516 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1JYUTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:19:30 -0400
MIME-Version: 1.0
Date: Tue, 25 Oct 2011 22:19:29 +0200
X-Google-Sender-Auth: MQNDvUPs-dHZGR_RdRVQwtQpL9E
Message-ID: <CAMuHMdXxqKoPNNo9a+VK-Yzu0Qp-8zY2+OhHL6pDPF=dsnNK5Q@mail.gmail.com>
Subject: drivers/net/ethernet/apple
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

drivers/net/ethernet/apple/mac89x0.c is a driver for the Crystal Semiconductor
(Now Cirrus Logic) CS89[02]0, so it belongs in drivers/net/ethernet/cirrus,
next to cs89x0.c.

And according to drivers/net/ethernet/apple/mace.h, "mace" is the
"Am79C940 MACE (Medium Access Control for Ethernet)", so mace and
macmace should be in drivers/net/ethernet/amd/.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
