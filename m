Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2AWTQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:16:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AWTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:16:16 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812C6D0D0@EXMAIL03.scwf.nsc.com>
References: <AczXFb0awj5rU2NWTZyzBVK6p9EmMg==>
	<B567DBAB974C0544994013492B949F8E3812C6D0D0@EXMAIL03.scwf.nsc.com>
Date: Mon, 23 Jan 2012 20:16:15 +0100
Message-ID: <CACRpkdb5rnNSVZBTVATi5i64ynz3zS+VfEx2Bi2tusTAMc2zDg@mail.gmail.com>
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

On Fri, Jan 20, 2012 at 2:49 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> To get information about brightness control mode, lm3530_mode_get() is added.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

When adding new ABIs, create a Documentation/ABI/testing/* file
for the new attribute explaining what it is and how it works.

Yours,
Linus Walleij
