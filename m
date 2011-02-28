Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1B1Wnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 17:43:55 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35374 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab1B1Wnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 17:43:53 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik3hiNj7=K+uE6eQW2CokZtCz7Zwvt-+6PkD_Mo@mail.gmail.com>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
	<201101061946.04790.arnd@arndb.de>
	<AANLkTikJMx2QxYwXS_TrKK5hcnD3G0MNvEiDO+xAZrpo@mail.gmail.com>
	<201101091955.05174.arnd@arndb.de>
	<AFCDDB4A3EA003429EEF1E7B211FDBBA334C0FB0E2@EXDCVYMBSTM005.EQ1STM.local>
	<AANLkTi=HvRTfo84L_VwOVtVq5hfb1g+9ueH6SX8FWF2b@mail.gmail.com>
	<AANLkTik3hiNj7=K+uE6eQW2CokZtCz7Zwvt-+6PkD_Mo@mail.gmail.com>
Date: Mon, 28 Feb 2011 23:43:52 +0100
Message-ID: <AANLkTimcBL6D7bGGt-QSWDEE=nnpK0hy1CQZK_JEmEYA@mail.gmail.com>
Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 suppor
From: Linus Walleij <linus.walleij@linaro.org>
To: Vitaly Wool <vitalywool@gmail.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Cc: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Pavan Savoy <pavan_savoy@sify.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 6:55 PM, Vitaly Wool <vitalywool@gmail.com> wrote:

> Making hardware work is, if course, a valid point, but porting a windows
> driver would do that as well, and it's not the reason to pull windows
> drivers' ports into mainline.

Yeah hm, that sounds like it has "drivers/staging" printed all over it then,
so either we solve these issues or we need to put it into staging so we
can get help from others in fixing it up (we have a similar situation with
the U8500 graphics stuff).

P-G do you think it would be proper to take this into staging for the
moment, or do you prefer to drive it outside the mainline kernel tree until
it lands in the proper place(s)?

Yours,
Linus Walleij
