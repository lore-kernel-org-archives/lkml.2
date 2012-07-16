Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2GPT1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:27:15 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44605 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2GPT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <4FE4B13E.10709@caviumnetworks.com>
References: <1339962373-3224-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com>
	<20120620152759.2caceb8c.yuasa@linux-mips.org>
	<20120620161249.GB29196@linux-mips.org>
	<4FE4B13E.10709@caviumnetworks.com>
Date: Mon, 16 Jul 2012 21:27:12 +0200
X-Google-Sender-Auth: 3zRs9Ed7_W2rWDcGqS4JdQG_7r4
Message-ID: <CAMuHMdXSGgH+M_2+xuzY2t_sGZto24=atv3Kaj+R-dWAUPzW7w@mail.gmail.com>
Subject: Re: [PATCH] MIPS: fix bug.h MIPS build regression
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Yoichi Yuasa <yuasa@linux-mips.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 7:54 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> On 06/20/2012 09:12 AM, Ralf Baechle wrote:
>>
>> On Wed, Jun 20, 2012 at 03:27:59PM +0900, Yoichi Yuasa wrote:
>>
>>> Commit: 3777808873b0c49c5cf27e44c948dfb02675d578 breaks all MIPS builds.
>>
>>
>> Thanks, fix applied.
>>
>
> Where was it applied?
>
> It doesn't show up in linux-next for 20120622, which is where it is needed.

It's also desperately needed in mainline for 3.5.

Ralf?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
