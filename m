Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab2JBLAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:00:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57775 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2JBLAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:00:37 -0400
MIME-Version: 1.0
In-Reply-To: <1349165603-24401-11-git-send-email-lee.jones@linaro.org>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
	<1349165603-24401-11-git-send-email-lee.jones@linaro.org>
Date: Tue, 2 Oct 2012 13:00:36 +0200
Message-ID: <CACRpkdYG_L3cxAo3BAkENTUoDx+HEDdHW8Ntv1ZdOqLJdFmfyQ@mail.gmail.com>
Subject: Re: [PATCH 10/10] ARM: ux500: Stop informing the regulator subsystem
 that we have full constraints
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 10:13 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The regulator_has_full_constraints() call is not required if we
> are booting with Device Tree as it's assumed in this case.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
