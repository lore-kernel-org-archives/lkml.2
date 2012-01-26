Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab2AZL4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:56:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56637 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2AZL4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:56:17 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812CD3E4B@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812C6D0D0@EXMAIL03.scwf.nsc.com>
	<CACRpkdb5rnNSVZBTVATi5i64ynz3zS+VfEx2Bi2tusTAMc2zDg@mail.gmail.com>
	<B567DBAB974C0544994013492B949F8E3812CD3E4B@EXMAIL03.scwf.nsc.com>
Date: Thu, 26 Jan 2012 12:56:16 +0100
Message-ID: <CACRpkdag_vEEfNjUAw=Q_L39TZjHLmxnh59tyjSpfrMtO10S8Q@mail.gmail.com>
Subject: Re: [PATCH 4/7] leds-lm3530: add 'lm3530_mode_get()' in the lm3530
 device attribute
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 3:02 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> Yes, but this patch is additional function for 'mode' device attribute.
> 'Mode' attribute already exists before this patch.
> Then, should I add some explanation under Documentation ?

OK I see, well I would take this opportunity to add it, but no big deal
to me.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
