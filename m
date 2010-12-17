Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab0LQLkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:40:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41948 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab0LQLkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:40:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SbLNss4EsvgaFFmqKt2+TwwIHOX76uXKaDmgZKChcqysiJ5mF/lTeuhc/KFmI4SGGD
         dw0bDALSsyfUv6T4yIyTUZVmjjvi1gGKCzAcVDc0NZcDDw81JJ/ITlxSS48kk301o3QK
         SoWA1vmvtStttuaAOSo2hFCn3hz+8XPRbnfh8=
MIME-Version: 1.0
In-Reply-To: <1292585094-28544-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
References: <1292585094-28544-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
Date: Fri, 17 Dec 2010 12:40:34 +0100
Message-ID: <AANLkTi=f6XPbsUiTSiFru2tj_XsQSu=-h898b0R2AePo@mail.gmail.com>
Subject: Re: [PATCH 07/11] Bluetooth: Add UART API functions to ldisc
From: Vitaly Wool <vitalywool@gmail.com>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Pavan Savoy <pavan_savoy@sify.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Par,

On Fri, Dec 17, 2010 at 12:24 PM, Par-Gunnar Hjalmdahl
<par-gunnar.p.hjalmdahl@stericsson.com> wrote:
> This patch adds new functions to control break and flow
> as well as changing UART baud rate directly through the ldisc API
> rather then using the TTY API directly.

What do you need that for?

> It also adds a boolean parameter so it is optional to register
> to the Bluetooth stack (for drivers where a separate module
> registers to the Bluetooth stack instead).

I never liked this idea and I don't like it now as it scatters the
changes needed to support devices you are aiming to support with your
changes.

Thanks,
   Vitaly
