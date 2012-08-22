Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab2HVPoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:44:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44910 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2HVPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <50346181.3010406@samsung.com>
References: <1345608318-15347-1-git-send-email-dianders@chromium.org>
	<50346181.3010406@samsung.com>
Date: Wed, 22 Aug 2012 08:44:03 -0700
X-Google-Sender-Auth: nD0spXx9Y50m95VxwCkqW5hweMg
Message-ID: <CAD=FV=UZM9b6++DkgemZA7qpAZgFN+NyyLjRecgSdjcEsu0YYA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: core: Add a capability for disabling mmc cards
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Chris Ball <cjb@laptop.org>,
        Will Newton <will.newton@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon,

On Tue, Aug 21, 2012 at 9:35 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>
> Hi Doug,
>
> I didn't know what purpose is.
> Why need to add the MMC_CAP2_NO_MMC?
> If card is SD or SDIO, mmc_attach_mmc(host) should not be entered.
> Could you explain to me in more detail?

Thanks for your feedback.  In this case I have a card that is an MMC
card so mmc_attach_sdio() and mmc_attach_sd() will fail.  If I let
mmc_attach_mmc() run it will actually find the MMC card.  However, on
this platform it is not valid to recognize MMC cards.

-Doug
