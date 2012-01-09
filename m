Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378Ab2AIUNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:13:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49932 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292Ab2AIUNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:13:04 -0500
MIME-Version: 1.0
In-Reply-To: <1326055714.13595.309.camel@deadeye>
References: <1326055714.13595.309.camel@deadeye>
Date: Mon, 9 Jan 2012 21:13:01 +0100
X-Google-Sender-Auth: kFGkwCS_Y_Mq7DkFjSp63cetpIs
Message-ID: <CAMuHMdV614Hb9dFykFNbkwf-6hqx36qg_W=66tNqsexEHQ8d0A@mail.gmail.com>
Subject: Re: [PATCH 1/2] topology: Check for missing CPU devices
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        linux-m68k@vger.kernel.org, debian-68k@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 21:48, Ben Hutchings <ben@decadent.org.uk> wrote:
> Commit ccbc60d3e19a1b6ae66ca0d89b3da02dde62088b ('topology: Provide
> CPU topology in sysfs in !SMP configurations') causes a crash at boot
> on a several architectures.  The topology sysfs code assumes that
> there is a CPU device for each online CPU whereas some architectures
> that do not support SMP or cpufreq do not register any CPU devices.
> Check for this before trying to use a device.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Thanks!
Works on its own or combined with "[PATCH 2/2] cpu: Register a generic
CPU device on architectures that currently do not".

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
