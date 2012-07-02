Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2GBMZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 08:25:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33434 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2GBMZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 08:25:43 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.43.174]
In-Reply-To: <CAK=WgbZo-8GXY9bVYGk0XZvqKrdaJZWeNkK1FhRWnH5doGYLjA@mail.gmail.com>
References: <1337687472-23009-1-git-send-email-ohad@wizery.com>
 <4FBDFC4A.1060602@codeaurora.org> <CAK=WgbaP5qSso_Eu=Oup4eqLDcorZ-qf=mysMKiEvOS=m7yLmg@mail.gmail.com>
 <4FCD276A.80505@codeaurora.org> <CAK=WgbZo-8GXY9bVYGk0XZvqKrdaJZWeNkK1FhRWnH5doGYLjA@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 2 Jul 2012 15:25:22 +0300
Message-ID: <CAK=WgbZb367zq0QCUuwFU+KtBY0gw_+rsN9fm2YnM-heT+54jA@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: block premature rproc booting
To: Stephen Boyd <sboyd@codeaurora.org>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Sjur, Ludovic, Loic

On Tue, Jun 5, 2012 at 1:57 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Jun 5, 2012 at 12:23 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> I thought we wanted to allow both calls to proceed in parallel? If we
>> don't care about that
>
> Yeah, I don't think we do.
>
>> then "announcing" it once the firmware is found the first time sounds correct.
>
> I agree. Though this patch may be moot very soon due to:
>
>>> The main reason we kept the get/put interface was to make it easier
>>> for you guys to adopt it, but I've been re-thinking lately whether we
>>> really want that interface. It's a problematic interface with
>>> non-negligible maintenance burden, and the code will be greatly
>>> simplified without it.
>>
>> If nobody in the kernel is using it why keep it?
>
> I was concerned that the non get/put interface might not suit
> everyone, and I planned to wait for another user or two to show up
> before I remove that interface.
>
> Since MSM's PIL is based on a get/put interface, I actually hoped to
> see if you guys can adopt the new interface before we ditch the
> get/put one.
>
>> If MSM needs we can add it back when we move to rproc.
>
> Thanks - that's the kind of feedback I wanted to get.

Sjur, Ludovic, Loic - what remoteproc API are you using today?

We'd like to get rid of the existing get/put interface and instead
have everyone use the boot/shutdown one, just like rpmsg is doing
today.

Are you ok with this change?

Thanks,
Ohad.
