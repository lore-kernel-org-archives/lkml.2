Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab2AJTcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 14:32:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38597 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2AJTcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 14:32:11 -0500
MIME-Version: 1.0
In-Reply-To: <4F04E96F.6040501@xenotime.net>
References: <20120104191656.de575406a93b3c5226c531b2@canb.auug.org.au>
	<4F04E96F.6040501@xenotime.net>
Date: Tue, 10 Jan 2012 20:32:09 +0100
X-Google-Sender-Auth: G87SRxNUXy1v2xbqd3DgSpp94DU
Message-ID: <CAMuHMdXg=Fr6HLCLJvGBJD6wsUKN0=nRi7rboQU6+i5NwTWe3w@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 4 (usb/otg)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 01:06, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 01/04/2012 12:16 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20120103:
>
>
>
> ERROR: "usb_add_hcd" [drivers/usb/otg/mv_otg.ko] undefined!
> ERROR: "usb_remove_hcd" [drivers/usb/otg/mv_otg.ko] undefined!

And now it's in Linus' tree, for m68k allmodconfig:

http://kisskb.ellerman.id.au/kisskb/buildresult/5361188/
http://kisskb.ellerman.id.au/kisskb/buildresult/5361013/

BTW, strange that this error never popped up in linux-next before for that
config. Perhaps it was masked by the paride/bpck6.c build failure?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
