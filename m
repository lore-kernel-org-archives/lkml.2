Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393Ab0GUTfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:35:01 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58585 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758985Ab0GUTe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TKdeTW8MGEfBpHaYaUcM97VVVeWyVdr7aQMEKCgW82cir1M2zXi2FTfzbjSSbXRLwd
         oj9jznpH/ItmsgRAcyLxf5a7wUpgmDQWyovb6vB5ADIWk/BEToeDPx5v3HrgHn9qPeAu
         FwFZiMHz/ErRZZ1B+8rYMnBsFGdwScpzC8TqQ=
MIME-Version: 1.0
In-Reply-To: <c79f7e0698d11050302082fc57c7fe98d2290aa2.1279719754.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279719754.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<c79f7e0698d11050302082fc57c7fe98d2290aa2.1279719754.git.qy03fugy@stud.informatik.uni-erlangen.de>
Date: Wed, 21 Jul 2010 21:34:56 +0200
X-Google-Sender-Auth: CTfpdZ-yfueXsCtIzpfzbDYKriE
Message-ID: <AANLkTin6URVYEuKgQtQQFZUL04G6tBLFQ1MRfb0QnV9y@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers/scsi: Remove dead CONFIG_WD33C93_PIO
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de,
        Ralf Baechle <ralf@linux-mips.org>, Osamu Tomita <tomita@cinet.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 15:57, Christian Dietrich
<qy03fugy@stud.informatik.uni-erlangen.de> wrote:
> CONFIG_WD33C93_PIO doesn't exist in Kconfig, therefore all existing
> references to it from the source can be removed.

I've just checked full-history-linux. It came from this commit:

Author: Osamu Tomita <tomita@cinet.co.jp>
Date:   Wed Mar 26 21:38:14 2003 -0600

    [PATCH] Complete support for PC-9800 sub-arch (9/9) SCSI

    This is the patch to support NEC PC-9800 subarchitecture
    against 2.5.65-ac4. (9/9)

    SCSI host adapter support.
     - BIOS parameter change for PC98.
     - Add pc980155 driver for old PC98.
     - wd33c93.c update error handler for eh_*.
     - wd33c93.h register to int for PIO mode.

But the driver was removed again about on year later:

commit 36f51e495878ff38d639fe3109a6cbaba6c4f2be
Author: Linus Torvalds <torvalds@ppc970.osdl.org>
Date:   Thu Jun 17 19:33:53 2004 -0700

    This removes the files orphaned by the earlier PC9800 removal

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
