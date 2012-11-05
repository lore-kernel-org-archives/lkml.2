Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2KEMhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:37:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34092 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2KEMhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:37:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpjdVMCuBdN-O+xxK=Dko-GTEjF5AYOeEMgWghJfB8EsA@mail.gmail.com>
References: <1351779602-13818-1-git-send-email-ulf.hansson@stericsson.com>
	<1351779602-13818-3-git-send-email-ulf.hansson@stericsson.com>
	<CACRpkdbZB4nhFQtLH-GxBSK99RFk7yhSYMhO5keVjyugrqr7JA@mail.gmail.com>
	<CAPDyKFpjdVMCuBdN-O+xxK=Dko-GTEjF5AYOeEMgWghJfB8EsA@mail.gmail.com>
Date: Mon, 5 Nov 2012 13:37:00 +0100
Message-ID: <CACRpkdZv0+Q1ohD7KMV5+nAkFrz+esWNHtV1EhtWz7Nrzcnt8Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: nomadik-ske-keypad - start using the apb_pclk
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 1:25 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 4 November 2012 19:12, Linus Walleij <linus.walleij@linaro.org> wrote:

>> If I understand correctly, the only "real" solution is to
>> implement the PM domains and have these enable the clocks.
>
> Agree.
>
> Although, since the pm_domain not yet exist, this as a way forward for
> now - to fix what is broken.

True. Fixing regressions is more important.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

> When the pm_domain is in place and when we decide to fold in the clock
> handling in there, we can move it.

OK for me.

>> An alternative may be to move this driver over to the AMBA bus,
>> because I think this device actually has primecell registers.
>> Then the bus will take care of the pclk for starters.
>
> You are definitely right, this driver can be converted into using the AMBA bus.
> Although, do you think that should be done _instead_ of going ahead
> with this patch or do you want that to be handled as a next and a
> separate step?

No, just a suggestion of possibilities...

Yours,
Linus Walleij
