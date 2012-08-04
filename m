Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2HDXIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 19:08:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46799 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2HDXIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 19:08:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120723121222.GA27187@avionic-0098.mockup.avionic-design.de>
References: <1334229961-1844-1-git-send-email-thierry.reding@avionic-design.de>
	<201205121256.14283.arnd@arndb.de>
	<20120723121222.GA27187@avionic-0098.mockup.avionic-design.de>
Date: Sun, 5 Aug 2012 01:08:06 +0200
Message-ID: <CACRpkdbFY3LaWOQ_7KsXzanfSr1_BE=kL4eugX1psofg6JSM_g@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Use seq_file's iterator interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 2:12 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Sat, May 12, 2012 at 12:56:14PM +0000, Arnd Bergmann wrote:

>> > This patch was requested by Arnd Bergmann here:
>> >
>> >         http://article.gmane.org/gmane.linux.ports.tegra/3535
>> >
>> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>> > Cc: Linus Walleij <linus.walleij@stericsson.com>
>> > Cc: Grant Likely <grant.likely@secretlab.ca>
>> > Cc: Arnd Bergmann <arnd@arndb.de>
>> > Cc: linux-kernel@vger.kernel.org
>>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>
> Grant, Linus,
>
> Is this good to go?

Applied to my devel branch for the v3.7 cycle,
thanks!

Yours,
Linus Walleij
