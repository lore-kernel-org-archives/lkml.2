Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab2FKVld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:41:33 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44801 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2FKVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:41:32 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-13-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-13-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 23:41:31 +0200
Message-ID: <CACRpkdbJ_3Br=RbfbNRBrtz6zc3MH_B6f9E-2aQk=XhMHPnnrA@mail.gmail.com>
Subject: Re: [PATCH 12/14] ARM: ux500: Correctly reference IRQs supplied by
 the AB8500 from Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:25 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The AB8500 driver has now been provided with IRQ domain support. This
> means we can request IRQs from any of it's uses via Device Tree. This
> patch advertises the AB8500 as an Interrupt Controller and provides the
> correct calls in the format the driver expects.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks good to me,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
