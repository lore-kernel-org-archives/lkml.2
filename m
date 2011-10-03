Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1JCIpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:45:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50620 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1JCIpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:45:01 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <CACRpkdaDXQRA-vGDFTi=yHkhbBh=NOak4sSMwzdFNyYO1aTU2Q@mail.gmail.com>
References: <1317388114.3935.2.camel@phoenix> <CACRpkdaDXQRA-vGDFTi=yHkhbBh=NOak4sSMwzdFNyYO1aTU2Q@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 3 Oct 2011 16:44:40 +0800
Message-ID: <CAF+7xWn9wbccwmQpipVMWG+8hP9EJZ0msh+6vWgh3MJp6POQ3Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] pinmux: fix pinctrl_register error handling
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/3 Linus Walleij <linus.walleij@linaro.org>:
> On Fri, Sep 30, 2011 at 3:08 PM, Axel Lin <axel.lin@gmail.com> wrote:
>
>> Hi Linus,
>> The fix is base on my understanding of the driver-model code,
>> and it is untested ( only compile test), thus I add [RFC] on subject line.
>> Also CC Greg KH who is the maintainer of drivers/base/*.
>
> You understand it better than me for sure, I have rebased the patch
> on the v9 patchset and applied it to my tree.
>
Hi Linus,
It seems it is not fixed in your v9.
I read the v9 patch from here:
https://lkml.org/lkml/2011/10/3/62

Regards,
Axel
