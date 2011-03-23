Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab1CWRzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:55:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57982 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab1CWRz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XEM4L9zcSUrV4v/Phtqs0iIa2eWjXbXuNiL3sUy+0UGL2sQzAZ/sMgzuGlOjY+Mpaz
         SBMjnjyGBSPMHi43994GTd9aKxEdmrECiMF5VKDnTQ7oiJfH8gUR5kMkS2Sf1pMaJoGG
         7Ja7Q8tglgcgVpxb8QGMmIE70ROCAgeHcMFR4=
MIME-Version: 1.0
In-Reply-To: <20110323142719.GA17369@suse.de>
References: <1300888803-26474-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
	<20110323142719.GA17369@suse.de>
Date: Wed, 23 Mar 2011 18:55:28 +0100
X-Google-Sender-Auth: cIuhBCYubGrsxdpPW31MwsMkx7E
Message-ID: <AANLkTikZD5qie4y=tRpZXuea9D+_vDSGLMr+20p_PVkC@mail.gmail.com>
Subject: Re: [PATCH 2/2] mach-ux500: Add CG2900 devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg KH <gregkh@suse.de>,
        Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/23 Greg KH <gregkh@suse.de>:

>>  arch/arm/mach-ux500/Makefile         |    4 +
>>  arch/arm/mach-ux500/board-mop500.c   |  160 ++++++++++++++++
>>  arch/arm/mach-ux500/devices-cg2900.c |  349 ++++++++++++++++++++++++++++++++++
>>  arch/arm/mach-ux500/devices-cg2900.h |   19 ++
>>  4 files changed, 532 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm/mach-ux500/devices-cg2900.c
>>  create mode 100644 arch/arm/mach-ux500/devices-cg2900.h
>
> As this touches ARM specific code, I need an ack from the ARM maintainer
> before I can take this through the staging tree.  Is there any way to
> make it part of your drivers/staging/ submission?  There are other
> examples in the staging tree already that do this, why not do that here
> as well?

Hm yeah maybe it's possible if you move devices-cg2900.*
to staging/cg2900, then split off the stuff in board-mop500.c into
some drivers/staging/cg2900/board-mop500-cg2900.c which
adds the device in some proper initcall.

Do you think it can be done P-G? I might have overestimated
the work involved in moving that stuff to /staging.

Yours,
Linus Walleij
