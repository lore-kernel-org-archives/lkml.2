Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2KJBjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:39:49 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34395 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2KJBjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:39:48 -0500
MIME-Version: 1.0
In-Reply-To: <1352473841.1814.35.camel@sauron.fi.intel.com>
References: <1350147809-19616-1-git-send-email-shijie8@gmail.com>
	<1351258892.1823.20.camel@sauron.fi.intel.com>
	<508B4586.4090600@freescale.com>
	<1352473841.1814.35.camel@sauron.fi.intel.com>
Date: Fri, 9 Nov 2012 20:39:47 -0500
Message-ID: <CAMiH66E9WTtt=6EhX9XVv9afErGd5Ajfg9qN6dVQhE5FEJVrTw@mail.gmail.com>
Subject: Re: [PATCH] mtd: gpmi: remove unneccessary header
From: Huang Shijie <shijie8@gmail.com>
To: dedekind1@gmail.com
Cc: Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 10:10 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Sat, 2012-10-27 at 10:23 +0800, Huang Shijie wrote:
>> 于 2012年10月26日 21:41, Artem Bityutskiy 写道:
>> > On Sat, 2012-10-13 at 13:03 -0400, Huang Shijie wrote:
>> > > The whole gpmi-nand driver has turned to pure devicetree supported.
>> > > So the linux/mtd/gpmi-nand.h is not neccessary now. Just remove it,
>> > > and move some macros to the gpmi-nand driver itself.
>> > >
>> > > Signed-off-by: Huang Shijie <shijie8@gmail.com>
>> > I cannot compile-test it because the MXS configuration file I always
>> I tested this patch in mxs and mx6q with the linux-next-20121026.
>> I do not meet such compiler errors.
>>
>> I think the l2-mtd tree is lack of some patches in other people's
>> tree.
>> In the current l2-mtd tree, even i DISABLE the gpmi driver, the kernel
>> still
>> meets the compiler errors.
>
> It is based on v3.7-rc4. Once the patches you refer are in Linus's tree,
> let me know. Thanks!
>
I re-created the .config based on the latest l2-mtd tree. I compiled
the kernel with this patch again, and
there is no compiler error anymore.

Could you re-create your mxs config with "make ARCH=ARM
mxs_defconfig", and test this patch again?

thanks
Huang Shijie

> --
> Best Regards,
> Artem Bityutskiy
