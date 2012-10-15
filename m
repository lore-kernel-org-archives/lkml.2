Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2JONkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:40:51 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:42650 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2JONkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:40:49 -0400
MIME-Version: 1.0
In-Reply-To: <CABjyUiLjhZxANU9pbQjFya5dqXW3D2-w0d-35tfZrcLd3TCscg@mail.gmail.com>
References: <CABjyUiLyfHFE6ew5JPaH4YSz5k1sm4HnZFm4e12v=_Pcp6jGNw@mail.gmail.com>
	<CALF0-+WP8_uLqFjSJ5YJ4_Hrpk2Y1+U_mx=baeGWSTpw+kTw2Q@mail.gmail.com>
	<CALF0-+Xg2GMCK3c7qpgH5pZq=EdcGf=zHJdS5SGSqLpOSRhbQA@mail.gmail.com>
	<CALF0-+X1VBfCi--=Dcc5163BCGCUQMPc=cADKg26T+j=jAwfSg@mail.gmail.com>
	<CABjyUiLjhZxANU9pbQjFya5dqXW3D2-w0d-35tfZrcLd3TCscg@mail.gmail.com>
Date: Mon, 15 Oct 2012 10:40:49 -0300
Message-ID: <CALF0-+WuqQ794iUzdCZRj3KxMyc5ZAnTe9+PWfndiZFVb1Q7og@mail.gmail.com>
Subject: Re: PROBLEM: Ali m5602 won't compile (3.4.9-gentoo)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Yuriy Davygora <davygora@googlemail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 10:21 AM, Yuriy Davygora
<davygora@googlemail.com> wrote:
>   Hi Ezequiel,
>
>   thank you very very much! This was indeed the problem. I wonder, why
> menuconfig did not warn me that USB is marked to be compiled as
> module, when I chose to build in the gspca support, but, nevertheless,
> now it works, so thanks again!
>

You're welcome.

If you ever report a problem to a mailing list,
please try to avoid top-posting and never drop Cc.
You just did both...

Thanks,

    Ezequiel
