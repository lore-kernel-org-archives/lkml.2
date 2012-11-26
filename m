Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab2KZV0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:26:14 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62292 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab2KZV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:26:12 -0500
MIME-Version: 1.0
In-Reply-To: <50B3C211.6000600@wwwdotorg.org>
References: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org>
	<1353349867-28494-11-git-send-email-swarren@wwwdotorg.org>
	<CACRpkdb-cmwTH_7EJO02m2+CCZrJ2ycgtGpf8stoiFKSm8jqww@mail.gmail.com>
	<50B3C211.6000600@wwwdotorg.org>
Date: Mon, 26 Nov 2012 22:26:10 +0100
Message-ID: <CACRpkdaFfKKVjS0e5dkHE-faaedOdRaQR8ObEmzq5X6ADuo0Ng@mail.gmail.com>
Subject: Re: [PATCH V3 10/11] ARM: remove struct sys_timer suspend and resume fields
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 8:25 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/21/2012 01:28 AM, Linus Walleij wrote:

>> Oh and there was this comment/TODO:
>> I was thinking that if your patch set is introducing a
>> plethora of new users of these hooks we should maybe
>> stick a patch at the beginning of the series renaming the
>> hooks to *_noirq, but if it's a major obstacle it can surely wait.
>
> I think I'd prefer to keep that rename separate and do it later; while
> this series does introduce a few new users of the type, there are many
> more pre-existing users. Renaming all the users would end up making this
> series potentially conflict with addition of new users in tip.git or
> elsewhere, whereas any possible current conflicts from this series
> should be resolvable in arm-soc pretty easily I hope, so I'd rather
> create a separate series that does the rename, and probably apply it to
> tip.git, probably for 3.10?

Sure no big deal.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
