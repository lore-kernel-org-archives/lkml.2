Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1KQVFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:05:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54069 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1KQVFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:05:42 -0500
MIME-Version: 1.0
In-Reply-To: <1321559636.20271.287.camel@x61.thuisdomein>
References: <1321180296-22543-1-git-send-email-geert@linux-m68k.org>
	<1321182176.20271.43.camel@x61.thuisdomein>
	<CAMuHMdXsHgUd_oggpKoS2t6Tm8MnEjLnWmi4Hswz_nQjSWsozA@mail.gmail.com>
	<1321559636.20271.287.camel@x61.thuisdomein>
Date: Thu, 17 Nov 2011 22:05:41 +0100
X-Google-Sender-Auth: AEzZP7A0j7-yLBGifjggHG23WqI
Message-ID: <CAMuHMdW73Nf+bP2u6NRZFMW5c0-PnqYCDtEbZ+weGLs_mzZ1_g@mail.gmail.com>
Subject: Re: [PATCH] m68k: Remove references to obsolete CONFIG_SERIAL167
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-m68k@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 20:53, Paul Bolle <pebolle@tiscali.nl> wrote:
> > But please keep SERIAL_CONSOLE.
>
> Why do you care about SERIAL_CONSOLE? If it's only really used by
> AMIGA_BUILTIN_SERIAL why shouldn't we rename it to
> AMIGA_BUILTIN_SERIAL_CONSOLE?

Because SERIAL_CONSOLE is a universal platform-independent symbol.
Other arches have it as well (but less than in the past).

As soon as m68k gets a new serial driver, it will be used by 2 drivers again.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
