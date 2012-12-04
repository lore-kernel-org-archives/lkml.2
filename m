Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2LDMbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 07:31:40 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53764 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2LDMbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:31:39 -0500
MIME-Version: 1.0
In-Reply-To: <20121204091215.GD2718@gmail.com>
References: <1354289099-17931-1-git-send-email-lee.jones@linaro.org>
	<CACRpkdafvpnyq7YMV=iSjN4+u1hpt3xntAb-daJZifG9VpgnOw@mail.gmail.com>
	<20121204091215.GD2718@gmail.com>
Date: Tue, 4 Dec 2012 13:31:37 +0100
Message-ID: <CACRpkdYn7tuCjNiy0KpDEefC3tMDjKSnaWKzM38URN9HQALT7Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Change IRQ from low-to-high edge
 triggered to high-to-low
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 10:12 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Sat, 01 Dec 2012, Linus Walleij wrote:
>
>> On Fri, Nov 30, 2012 at 4:24 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > When the STMPE IRQ is triggered to be active high level-sensitive, the
>> > Nomadik GPIO controller it uses complains, although it still works.
>> > Recently we attempted to move triggering to low-to-high in an attempt
>> > to prevent the warning; however, this ensured that the IRQ was actually
>> > missed completely. Now we have a solution which both works and keeps the
>> > GPIO controller happy.
>> >
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> Is this something I should put into the ux500 tree or will you
>> take care of this in a separate pull request?
>
> Can you still get this into the RCs, as it's a bugfix?

Well it doesn't apply to the -rc:s since it's patching
arch/arm/boot/dts/stuib.dtsi which does not exist in
the v3.7 series.

Either what you want is to submit a fix to Arnd & Olof
on top of your previous DT patches, or you need to send
a rebased version...

Yours,
Linus Walleij
