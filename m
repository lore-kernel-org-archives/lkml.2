Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0KGLot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 06:44:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55176 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0KGLor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 06:44:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rBrOitsG3qQAADsm6kyuy/QG/GVcynw8ocA4Hx9vgSfbkJafZ8l2lwKjiP3QYzl3w5
         k00qzLO2L6yhp+gGtcMDQq6Vofty8lOkY83o2hGTaEk7xQGxwUt7E5zT+t3NqH7u5wVX
         vlgSTNZSdOTO0R4yI7KCnlwCaRMT5LWAKVybQ=
MIME-Version: 1.0
In-Reply-To: <39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
Date: Sun, 7 Nov 2010 13:44:45 +0200
Message-ID: <AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
Subject: Re: Forked android kernel development from linux kernel mainline
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 7, 2010 at 10:38 AM, Elvis Dowson <elvis.dowson@mac.com> wrote:
> HI Greg,
>
> On Nov 6, 2010, at 10:12 PM, Greg KH wrote:
>
>> Are you willing to maintain the android kernel code in the mainline
>> kernel tree?  If so, I will be glad to add it back in, but as no one was
>> willing to do the work, it was removed.  It's as simple as that.
>
> I'm willing to do this. I'll start off initially with support for TI OMAP 35xx
> and TI OMAP 4440, build and test initially on the Gumstix Overo,
> BeagleBoard and PandaBoard.
>
> I'll start with v2.6.37-rc1 and android-froyo-2.2, and try to do the required
> changes to get it accepted into mainline by v2.6.39.
>
> Elvis Dowson

Read this: https://wiki.linaro.org/Releases/1105?action=AttachFile&do=get&target=Linaro+Cycle+2+Requirements+18+September+2010.pdf
( http://is.gd/gNP7y )

[quote]
Android Strategy
Sponsor: Yves V. (Freescale)
Leads: Loïc, Scott B.
WGs: Kernel Consolidation, Toolchain
...

A2.2 Support upstreaming of Android patches
[/quote]

Linaro is going in the same direction.
