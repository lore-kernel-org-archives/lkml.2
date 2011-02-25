Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab1BYRIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:08:18 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:51701 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab1BYRIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:08:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SAeDEx0uq+DpEcAgqp8QbmY5cc4YDZjdathVqhGLTtB/Yze93U9OV/jJYqYho+iFXX
         TILS29fLbfk7sZfRcH5AmOFSj9yJJ0nh8NYsTZGx3yPmKfBlFG2wJywxLtVs9lgZ7vsU
         KNyNhnSNGK/nIMr88DTJ+DeaqQ5LPli0yvoJU=
MIME-Version: 1.0
In-Reply-To: <AFCDDB4A3EA003429EEF1E7B211FDBBA334C0FB0E2@EXDCVYMBSTM005.EQ1STM.local>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
	<201101061946.04790.arnd@arndb.de>
	<AANLkTikJMx2QxYwXS_TrKK5hcnD3G0MNvEiDO+xAZrpo@mail.gmail.com>
	<201101091955.05174.arnd@arndb.de>
	<AFCDDB4A3EA003429EEF1E7B211FDBBA334C0FB0E2@EXDCVYMBSTM005.EQ1STM.local>
Date: Fri, 25 Feb 2011 18:08:16 +0100
X-Google-Sender-Auth: LacOkGoqEm-33rwyJdf8vRKl6CM
Message-ID: <AANLkTi=HvRTfo84L_VwOVtVq5hfb1g+9ueH6SX8FWF2b@mail.gmail.com>
Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 suppor
From: Linus Walleij <linus.walleij@linaro.org>
To: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Pavan Savoy <pavan_savoy@sify.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/24 Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>:

> I sent the mail below one month ago, but have still not received any answers or further comments.
> Has anyone of you who made comments on the CG2900 patches earlier, any more comments or questions?

I think I have provided
Acked-by: Linus Walleij <linus.walleij@linaro.org>
(or the earlier ST-Ericsson address, which is equal) for these patches.
Else I do so now.

FWIW: I think those who want another architectural solution
can propose a refactoring patch any day they like, and if it's
recieved like "ah, that's better" ACK from Pär-Gunnar et al, then
it's no big deal.

This makes the hardware work with 2.6.39 which is really most
important IMO, Sam can you merge this as it stands?

Yours,
Linus Walleij
