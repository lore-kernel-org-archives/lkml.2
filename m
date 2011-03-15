Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1COJHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:07:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50033 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1COJHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:07:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110314181531.GA32434@opensource.wolfsonmicro.com>
References: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
	<20110311153134.GO1760@opensource.wolfsonmicro.com>
	<AANLkTinD9fO9Tyft0CQABMea2SbcHexNmYT9_ND_Yb-M@mail.gmail.com>
	<20110314181531.GA32434@opensource.wolfsonmicro.com>
Date: Tue, 15 Mar 2011 10:07:50 +0100
Message-ID: <AANLkTi=W980GYHVxdYPV3xNKcdGpjAewKssoUc3ZoEDi@mail.gmail.com>
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

On Mon, Mar 14, 2011 at 7:15 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Mar 14, 2011 at 05:42:28PM +0100, Linus Walleij wrote:
>
>> Mark can you pick this into the regulator tree? I have sent my ux500
>> tree upstream.
>
> No, I can't do that - mostly because Liam manages the regulator tree and
> not me :)

Ah yeah now I remember. Liam, please?

Yours,
Linus Walleij
