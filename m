Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab1KKIkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 03:40:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50172 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab1KKIkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 03:40:31 -0500
MIME-Version: 1.0
In-Reply-To: <201111101941.59570.dmitry.torokhov@gmail.com>
References: <20111111131159.848e724c5a9257d0b9f0f0f9@canb.auug.org.au>
	<201111101941.59570.dmitry.torokhov@gmail.com>
Date: Fri, 11 Nov 2011 14:10:31 +0530
Message-ID: <CAJuYYwTr3zzQobV9irFda_xMW8Sg_zCycGJFd+DiXc12FbP7FA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the input tree with the s5p tree
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 11 November 2011 09:11, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi Stephen,
>
> On Thursday, November 10, 2011 06:11:59 PM Stephen Rothwell wrote:
>> Hi Dmitry,
>>
>> Today's linux-next merge of the input tree got a conflict in
>> drivers/input/keyboard/Kconfig between commit 007205aa47e9 ("input:
>> samsung-keypad: Add HAVE_SAMSUNG_KEYPAD config option") from the s5p
>> tree and commit 5862c02d745f ("Input: samsung-keypad - enable compiling
>> on other platforms") from the input tree.
>>
>> I have fixed it up (probably incorrectly - see below) and can carry the
>> fix as necessary.
>
> Please drop the whole HAVE_SAMSUNG_KEYPAD thing; HAVE_CLK is all
> this driver needs. Expanding beyond Samsung will allow greater
> compile coverage.

Thanks for the suggestion. I will modify device tree support for
samsung keypad driver that is merged in s5p tree for-next branch.

Regards,
Thomas.

>
> Thanks.
>
> --
> Dmitry
>
