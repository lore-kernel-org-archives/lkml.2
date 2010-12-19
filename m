Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab0LSVaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:30:24 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:61102 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0LSVaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:30:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=sA3i3+nZ+Vu6OH1mLY25MFxgW+QLstUfDtmdL+dV+lx8GInEwZ2OYyVzvHmKhFlpPk
         duQCicCHbBsv5p0x6zyEvyz2oRNSf1SxM36DReLKtksDbzbt4te5m952Iz30+VWlX0j1
         2H1MRnx2zKyFTbAJmpFt9AYWzf3II+f10sm5s=
MIME-Version: 1.0
In-Reply-To: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
Date: Sun, 19 Dec 2010 22:23:32 +0100
X-Google-Sender-Auth: exgSHZ63gFMBnMviuT_6-DmFqnY
Message-ID: <AANLkTimCYea+G7Z+o-2BDCGHbRobM2n+VJLLcDO6g=9d@mail.gmail.com>
Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/17 Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>:

> This is the 3rd patch set for the ST-Ericsson CG2900 connectivity
> controller. The CG2900 is a combo controller supporting GPS, Bluetooth,
> and FM radio. It uses HCI H:4 protocol to combine different functionalities
> on a common transport, where first byte in the data indicates the current
> channel. Channels 1-4 are standardized in the Bluetooth Core specification
> while the other channels are vendor specific.

I'm slightly confused by different comment threads on this patch set.

I would certainly appreciate if the subsystem maintainers and reviewers
who shaped this patch set could add their Acked-by to the parts
they're happy with.

Alan, Marcel, Sam & Arnd especially. (Your work is MUCH
appreciated.)

I'm trying to get an idea of what patches are OK and what patches
are being disputed here, so as to whether there is some consensus
or not.

Yours,
Linus Walleij
