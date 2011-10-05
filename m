Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934744Ab1JENZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 09:25:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35412 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934700Ab1JENZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 09:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAF+7xWn9wbccwmQpipVMWG+8hP9EJZ0msh+6vWgh3MJp6POQ3Q@mail.gmail.com>
References: <1317388114.3935.2.camel@phoenix>
	<CACRpkdaDXQRA-vGDFTi=yHkhbBh=NOak4sSMwzdFNyYO1aTU2Q@mail.gmail.com>
	<CAF+7xWn9wbccwmQpipVMWG+8hP9EJZ0msh+6vWgh3MJp6POQ3Q@mail.gmail.com>
Date: Wed, 5 Oct 2011 15:25:26 +0200
Message-ID: <CACRpkdYyAjx_M4z4XhPvZXzVL0TrBOMuN55rSH5NG4wnNayzVw@mail.gmail.com>
Subject: Re: [RFC][PATCH] pinmux: fix pinctrl_register error handling
From: Linus Walleij <linus.walleij@linaro.org>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 10:44 AM, Axel Lin <axel.lin@gmail.com> wrote:
> 2011/10/3 Linus Walleij <linus.walleij@linaro.org>:
>> You understand it better than me for sure, I have rebased the patch
>> on the v9 patchset and applied it to my tree.
>>
> Hi Linus,
> It seems it is not fixed in your v9.
> I read the v9 patch from here:
> https://lkml.org/lkml/2011/10/3/62

I have not squashed it into my patch, instead I applied it on top and
pushed it to my for-next branch.

Hopefully if you check in linux-next it'll be there...

Yours,
Linus Walleij
