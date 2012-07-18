Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2GRIfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 04:35:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39149 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2GRIfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 04:35:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXSGgH+M_2+xuzY2t_sGZto24=atv3Kaj+R-dWAUPzW7w@mail.gmail.com>
References: <1339962373-3224-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com>
	<20120620152759.2caceb8c.yuasa@linux-mips.org>
	<20120620161249.GB29196@linux-mips.org>
	<4FE4B13E.10709@caviumnetworks.com>
	<CAMuHMdXSGgH+M_2+xuzY2t_sGZto24=atv3Kaj+R-dWAUPzW7w@mail.gmail.com>
Date: Wed, 18 Jul 2012 10:35:46 +0200
X-Google-Sender-Auth: Lzm0-Z199Mg_WHoF2uOaDRblHeE
Message-ID: <CAMuHMdWW=sAff-iw0EiHaejr34Z4u_X7w3nHf6Tfo-c2f=Qijg@mail.gmail.com>
Subject: Re: [PATCH] MIPS: fix bug.h MIPS build regression
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Daney <ddaney@caviumnetworks.com>,
        Andrew Morton <akpm@linux-foundation.org>
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

On Mon, Jul 16, 2012 at 9:27 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Jun 22, 2012 at 7:54 PM, David Daney <ddaney@caviumnetworks.com> wrote:
>> On 06/20/2012 09:12 AM, Ralf Baechle wrote:
>>>
>>> On Wed, Jun 20, 2012 at 03:27:59PM +0900, Yoichi Yuasa wrote:
>>>
>>>> Commit: 3777808873b0c49c5cf27e44c948dfb02675d578 breaks all MIPS builds.
>>>
>>>
>>> Thanks, fix applied.
>>>
>>
>> Where was it applied?
>>
>> It doesn't show up in linux-next for 20120622, which is where it is needed.
>
> It's also desperately needed in mainline for 3.5.
>
> Ralf?

Andrew? This prevents any green MIPS builds.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
