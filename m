Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2JPRfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:35:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35010 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2JPRfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:35:22 -0400
MIME-Version: 1.0
In-Reply-To: <1350393841-29698-1-git-send-email-stigge@antcom.de>
References: <1350393841-29698-1-git-send-email-stigge@antcom.de>
Date: Tue, 16 Oct 2012 19:35:21 +0200
Message-ID: <CACRpkdYGbK1ERErLhrT-9AzDEq=wLGneAbSx-5KCrTs_uxB9_w@mail.gmail.com>
Subject: Re: [PATCH] gpio-74x164: Fix buffer allocation size
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: maxime.ripard@free-electrons.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 3:24 PM, Roland Stigge <stigge@antcom.de> wrote:

> The new registers handling in the gpio-74x164 driver allocates chip->registers
> * 8 bytes where only one byte per register is necessary. This patch fixes this.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Patch applied to my fixes branch unless someone shouts...

Yours,
Linus Walleij
