Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2DGCau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 22:30:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61473 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2DGCat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 22:30:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120406182122.GA13649@pengutronix.de>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de>
	<1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
	<CAMiH66EC7=x0sRYhE3hpEyBemDGSRS19xguQUqKj2kuPw5Tifw@mail.gmail.com>
	<20120404122335.GD17187@pengutronix.de>
	<CAMiH66GM0RxP-z=HNkOhhPaaXCZLKPvWFy=_+aGbbGSdrsg+iQ@mail.gmail.com>
	<20120406182122.GA13649@pengutronix.de>
Date: Fri, 6 Apr 2012 22:30:48 -0400
Message-ID: <CAMiH66GxZoT-PDfkqBOFfn2jXi6n7B0jiDmMUV9GpT09J3z2yQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
From: Huang Shijie <shijie8@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 6, 2012 at 2:21 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>
>> > where 2-4 can probably happen more or less simultaneously.
>> I wish you could send out the new patch as soon as possible. :)
>
> Is a new version needed? I thought that this version could go in...

emm..
If you think this version is ok, I will ask Artem to accept another patch:
"  mtd/gpmi : do not include the mxs.h".

My other patches depend on this patch. And they have been delayed for some time.

thanks
Huang Shijie

>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
