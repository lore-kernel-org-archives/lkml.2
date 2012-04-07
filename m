Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2DGNpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 09:45:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56424 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab2DGNpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 09:45:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120407080032.GA17369@pengutronix.de>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de>
	<1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
	<CAMiH66EC7=x0sRYhE3hpEyBemDGSRS19xguQUqKj2kuPw5Tifw@mail.gmail.com>
	<20120404122335.GD17187@pengutronix.de>
	<CAMiH66GM0RxP-z=HNkOhhPaaXCZLKPvWFy=_+aGbbGSdrsg+iQ@mail.gmail.com>
	<20120406182122.GA13649@pengutronix.de>
	<CAMiH66GxZoT-PDfkqBOFfn2jXi6n7B0jiDmMUV9GpT09J3z2yQ@mail.gmail.com>
	<20120407080032.GA17369@pengutronix.de>
Date: Sat, 7 Apr 2012 21:45:37 +0800
Message-ID: <CAMiH66F4ev=M12Bav+kO6vYBdDkGFpBAPCwkgf5jRJHbRj=bpw@mail.gmail.com>
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

On Sat, Apr 7, 2012 at 4:00 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>> emm..
>> If you think this version is ok, I will ask Artem to accept another patch:
>> "  mtd/gpmi : do not include the mxs.h".
>>
>> My other patches depend on this patch. And they have been delayed for some time.
>
> Please wait at least somebody acknowledged that this has been picked up.
> linux-next will break otherwise.
>

ok, thanks.

Huang Shijie
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
