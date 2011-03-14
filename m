Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1CNQma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:42:30 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43846 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1CNQm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:42:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110311153134.GO1760@opensource.wolfsonmicro.com>
References: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
	<20110311153134.GO1760@opensource.wolfsonmicro.com>
Date: Mon, 14 Mar 2011 17:42:28 +0100
Message-ID: <AANLkTinD9fO9Tyft0CQABMea2SbcHexNmYT9_ND_Yb-M@mail.gmail.com>
Subject: Re: [PATCH] regulator: switch the ab3100 to use enable_time()
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 4:31 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Mar 11, 2011 at 04:26:18PM +0100, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This switches the ab3100 core to use the enable_time()
>> infrastructure from the regulator core.
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Mark can you pick this into the regulator tree? I have sent my ux500
tree upstream.

Yours,
Linus Walleij
