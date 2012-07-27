Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2G0WhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 18:37:07 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35887 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2G0WhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 18:37:05 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxrbbbC9eSCCh=s1mrNk=bz=og2B-FxmoYpVuxVvMrRqQ@mail.gmail.com>
References: <CACRpkdZnRiZpKuQ6krJFa8TAfmvYYLB-n79ztzaUOV32p6ZY1Q@mail.gmail.com>
	<CA+55aFxrbbbC9eSCCh=s1mrNk=bz=og2B-FxmoYpVuxVvMrRqQ@mail.gmail.com>
Date: Sat, 28 Jul 2012 00:37:05 +0200
Message-ID: <CACRpkdYz1XMWJ4GsbudYv=rtkkOsmQFqfptBVAbY9hgLcesBgg@mail.gmail.com>
Subject: Re: [GIT PULL] GPIO changes for v3.6
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        =?ISO-8859-1?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 10:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jul 25, 2012 at 3:48 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>
>> in Grants absence, these are my queued and -next-tested changes
>> for v3.6, please pull them in. Grants "merge" branch prior to his
>> absence was merged in as a base for this patch series.
>
> Please verify my conflict resolution in drivers/gpio/gpio-mxc.c.
>
> The resolution seemed pretty straight-forward, but I obviously didn't
> test the result, so it would be best to double-check,

LooksGoodToMe(TM).

Better page the MXC people so they can scream if something
goes wild.

Yours,
Linus Walleij
