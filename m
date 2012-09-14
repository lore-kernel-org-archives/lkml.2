Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab2INN6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:58:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37882 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab2INN6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:58:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120914091037.GI3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-11-git-send-email-lee.jones@linaro.org>
	<CACRpkdY_gyWRO20ZOfTmG=tzE_B3ObWZG_4f8gHS6vyiGZSh6Q@mail.gmail.com>
	<20120914091037.GI3374@gmail.com>
Date: Fri, 14 Sep 2012 15:58:13 +0200
Message-ID: <CACRpkdbdPgQHT=F-sGULD=fqSo0-7vyRAUbPTNXM41Fn5nUdzw@mail.gmail.com>
Subject: Re: [PATCH 10/19] ARM: ux500: Remove redundant #gpio-cell properties
 from HREF and Snowball DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:10 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, Sep 10, 2012 at 04:12:23AM -0700, Linus Walleij wrote:
>> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > These properties have no place here as the populated nodes are
>> > not related to GPIO Controllers.
>> >
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> Squash this into the previous patch adding them...
>> I think Arnd already noted.
>
> Well he noted that I'd duplicated the error from the snowball.dts
> file, then rectified in this patch, which is fair enough. However,
> I don't think the snowball.dts fix should be squashed into an HREF
> enablement patch, and I can't find a suitable patch in the patch-
> set where it would really fit. Should I leave the Snowball fix
> separate and just fixup the HREF .dts file to never duplicate the
> anomaly?

No you're right, this should be separate.

I was confused that it was in the same patch set, I would
suggest just sending this one on it's own as a snowball fix
fair and square, and have ARM SoC push it to the -rcs as a
regression fix, but your choice.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
