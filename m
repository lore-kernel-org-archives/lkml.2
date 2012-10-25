Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935845Ab2JYQEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:04:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47767 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab2JYQEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:04:01 -0400
MIME-Version: 1.0
In-Reply-To: <20121025155143.GK4008@gmail.com>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
	<1351089926-32161-3-git-send-email-lee.jones@linaro.org>
	<CACRpkda2NQok7kzh0pFmZPYd4nky1kUw=67DZAYAJAXGuc1yzQ@mail.gmail.com>
	<CACRpkdbNWE6hOdVFPxHv7MVHkZUBW3LC035CxJkZVmr8j05Kqw@mail.gmail.com>
	<20121025155143.GK4008@gmail.com>
Date: Thu, 25 Oct 2012 18:03:59 +0200
Message-ID: <CACRpkdbkcgE-qwuGgOvK9jGTj-0qy3eTFLsN3LYe1G17LmHk9g@mail.gmail.com>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 5:51 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 25 Oct 2012, Linus Walleij wrote:

>> Probably some driver is needing a clk_get() or a clk_get_sys() is
>> needs to be added somewhere to bring up some vital cluster,
>> or there may be some out-of-tree driver needed to bring up the
>> cluster properly I have no clue... Maybe some cluster just
>> cannot be declocked like that.
>
> I leave work in 10 mins and won't be coding again for ~2.5 weeks.
> So if this is something you could squeeze in and fix-up, I'd be
> very grateful.

I'll try. It doesn't look right that a clk_prepare() in the pinctrl
driver is saving the day for somebody else...

Yours,
Linus Walleij
