Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030363Ab2EPLw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:52:28 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34079 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967466Ab2EPLw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:52:26 -0400
MIME-Version: 1.0
In-Reply-To: <1337168453.4107.44.camel@deadeye>
References: <1337157810-13494-1-git-send-email-geert@linux-m68k.org>
	<1337168453.4107.44.camel@deadeye>
Date: Wed, 16 May 2012 13:52:25 +0200
X-Google-Sender-Auth: bISjB5WMukSftyfTKxxAsbMIpsA
Message-ID: <CAMuHMdUa5JbopxqvoZ6rRivM4Go+cY7ZpijtB+FACuo+-TiZwA@mail.gmail.com>
Subject: Re: [PATCH] ptp_pch: Add missing #include <linux/slab.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Takahiro Shimizu <tshimizu818@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 1:40 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Wed, 2012-05-16 at 10:43 +0200, Geert Uytterhoeven wrote:
>> drivers/ptp/ptp_pch.c: In function 'pch_eth_enable_set':
>> drivers/ptp/ptp_pch.c:152:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
>> drivers/ptp/ptp_pch.c:153:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
>
> <linux/io.h> might be more useful.

Bummer, I copied the wrong error from the log ;-(
I resent the correct version.

But indeed, <linux/io.h> is also missing. But that error was not a regression
in 3.4-rc7 ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
