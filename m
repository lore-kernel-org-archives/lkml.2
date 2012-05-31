Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab2EaBkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 21:40:14 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41465 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2EaBkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 21:40:13 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbQv8Q07iRAmG3UQRm7UNDi_Y+s_vvACDKKxR9tg+1iqg@mail.gmail.com>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
	<1338353260-10097-9-git-send-email-lee.jones@linaro.org>
	<CACRpkdbQv8Q07iRAmG3UQRm7UNDi_Y+s_vvACDKKxR9tg+1iqg@mail.gmail.com>
Date: Thu, 31 May 2012 09:40:10 +0800
Message-ID: <CACRpkdbFgwF+rYthawxn8mW90u_BP0c+h=GODwQk5VwTF+JdqQ@mail.gmail.com>
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 2:58 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, May 30, 2012 at 12:47 PM, Lee Jones <lee.jones@linaro.org> wrote:
>
>> The 'name' field in 'struct of_regulator_match' expects to match with
>> its corresponding regulator device node in the Device Tree. This patch
>> renames each of the regulators in the ab8500 regulator driver so this
>> is true.
>
> Anyway: the name is used in more parts of the file, so please change
> it everywhere if you change it.

I was wrong on this, ignore that comment. I understand this now...
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
