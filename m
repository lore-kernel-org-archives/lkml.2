Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2EGLJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:09:49 -0400
Received: from mail-gh0-f179.google.com ([209.85.160.179]:49970 "EHLO
	mail-gy0-f179.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752795Ab2EGLJs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:09:48 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2012 07:09:48 EDT
MIME-Version: 1.0
In-Reply-To: <20120507090427.GA26654@gondor.apana.org.au>
References: <20120507121137.bdfc96ed31649040506d9c75@canb.auug.org.au>
	<201205070809.21709.arnd@arndb.de>
	<20120507090427.GA26654@gondor.apana.org.au>
Date: Mon, 7 May 2012 13:02:48 +0200
Message-ID: <CACRpkdar8OLHcBmm5cDT7S_V1dbLG0L5FXuvw0=bhEjkjz88Pw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the crypto tree with Linus' tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Westin <andreas.westin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 11:04 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, May 07, 2012 at 08:09:21AM +0000, Arnd Bergmann wrote:
>> On Monday 07 May 2012, Stephen Rothwell wrote:
>> > + static void __init u8500_cryp1_hash1_init(void)
>> > + {
>> > +       db8500_add_cryp1(&u8500_cryp1_platform_data);
>> > +       db8500_add_hash1(&u8500_hash1_platform_data);
>> > + }
>>
>> This is actually not correct any more because of the
>> other changes: each device addition should also pass the parent
>> pointer so the device is created in the right position.
>>
>> Stephen, your fix is ok for linux-next and I expect everything
>> to still work, but we should not merge it into v3.5 this way.
>>
>> Thanks for the fixup.
>
> OK, I'll drop the last patch
>
>        mach-ux500: crypto - core support for CRYP/HASH module

OK we need to revisit this and we can drop the U5500 hunks at
the same time.

Yours,
Linus Walleij
