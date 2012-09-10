Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2IJRnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:43:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39151 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2IJRnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:43:22 -0400
MIME-Version: 1.0
In-Reply-To: <504E2583.4070602@wwwdotorg.org>
References: <1347265874-3342-1-git-send-email-linus.walleij@stericsson.com>
	<504E2583.4070602@wwwdotorg.org>
Date: Mon, 10 Sep 2012 19:43:21 +0200
Message-ID: <CACRpkdY5RdKDgU3_aR7G2jd2C-s=dpjsjF=0v_9zA6Ek5JpfTA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/nomadik : add MC1_a_2 pin MC1 function group list
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:38 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/10/2012 02:31 AM, Linus Walleij wrote:
>> From: Patrice Chotard <patrice.chotard@stericsson.com>
>>
>> Another possible pin configuration for the MC1 pin group.
>
> I have no objection to this, but I wonder if these will keep trickling
> in. Is it a good idea to audit the whole driver and add everything
> that's missing in one go?

I think Patrice has most of it working and is adding the minor missing
pieces to make it perfect ... in our case the group set is driven from
usecases rather than specification, and we have a few different
boards around.

Yours,
Linus Walleij
