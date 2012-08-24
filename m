Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab2HXHeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:34:36 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49488 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2HXHed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:34:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120824003315.GA3360@roeck-us.net>
References: <1345754768-4634-1-git-send-email-geert@linux-m68k.org>
	<5036AC23.8020309@xenotime.net>
	<20120824003315.GA3360@roeck-us.net>
Date: Fri, 24 Aug 2012 09:34:33 +0200
X-Google-Sender-Auth: jZB5rU7_4tUcPrXNA1690Z6sdSY
Message-ID: <CAMuHMdVK0M4eadPsazmTtBTVaXvo5WXDFS+VTaLaXcgCeDk2NQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.6-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 2:33 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Thu, Aug 23, 2012 at 03:18:11PM -0700, Randy Dunlap wrote:
>> On 08/23/2012 01:46 PM, Geert Uytterhoeven wrote:
>>
>> > *** ERRORS ***
>> >
>> > 54 regressions:
>>
>>
>> >   + drivers/net/can/usb/peak_usb/pcan_usb_core.c: error: conflicting types for 'dump_mem':  => 56:6
>> >   + drivers/net/can/usb/peak_usb/pcan_usb_core.h: error: conflicting types for 'dump_mem':  => 134:6
>>
>> Anyone see what causes this?  I looked but failed to see
>> the problem.
>>
> sh target, maybe ? dump_mem is declared as global function in arch/sh/include/asm/kdebug.h.
> Does not seem to be the best name for a global function.

Yep, sh-allyesconfig/sh-allmodconfig.

arch/sh/include/asm/kdebug.h:15:13: note: previous declaration of
'dump_mem' was here

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
