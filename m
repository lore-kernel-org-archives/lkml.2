Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2HTPSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:18:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39575 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab2HTPSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:18:31 -0400
MIME-Version: 1.0
In-Reply-To: <1345474316.9850.4.camel@phoenix>
References: <1345465097-31576-1-git-send-email-linus.walleij@stericsson.com>
	<1345474316.9850.4.camel@phoenix>
Date: Mon, 20 Aug 2012 17:18:28 +0200
Message-ID: <CACRpkdZFNhDbAYkcbWhRmOpos_Vbjk0P4SSNCMCC3MXddzc4ZA@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500: fix voltage selector regression
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 4:51 PM, Axel Lin <axel.lin@gmail.com> wrote:
> 於 一，2012-08-20 於 14:18 +0200，Linus Walleij 提到：
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> Commit 3bf6e90e476fb34ca47b6dda270f41d9cebcb1ac
>> "regulator: Convert ab8499 to use get_voltage_sel()"
>> and commit ae713d394d9e2aacaab620acd3212855f1f06b00
>> "regulator: Convert ab8500 to set_voltage_sel"
>> corrupted the voltage selector mechanism is two ways:
>
> I'm not very sure the commits you mentioned is the root cause,
> because it looks that here is no behavior change with both commits.
> Does it really work if you revert above commits you mention?

No you're right, I've screwed up completely... I confused
two codebases. I'll fix a proper patch adding the proper
voltage shift fields to the regulator info.

Sorry about this Axel!

Yours,
Linus Walleij
