Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3ADKtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 05:49:11 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:61646 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3ADKtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 05:49:09 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAMVG2svQkEZtz_kod-ifp1y=pwOPa4ZyRnsayf=oyzHzyRsotw@mail.gmail.com>
References: <CA+icZUVEBEerN=YRSS8Rx-2Xvx4byFuBDbVcE45qq4QZ67+Q-A@mail.gmail.com>
	<CAMVG2svQkEZtz_kod-ifp1y=pwOPa4ZyRnsayf=oyzHzyRsotw@mail.gmail.com>
Date: Fri, 4 Jan 2013 11:49:06 +0100
Message-ID: <CA+icZUXeNFfAwugKZMuy2Arnt0UU2stX5FbuOc=P_B+Rg5oQAw@mail.gmail.com>
Subject: Re: 3.8-rc2: EFI framebuffer lock inversion...
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel J Blueman <daniel@quora.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 3:39 PM, Daniel J Blueman <daniel@quora.org> wrote:
> On 3 January 2013 22:11, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> Hi Daniel,
>>
>> just wanted to test the fb-fix [2] from Alan and followed the thread in [1].
>> Me is also working with i915 KMS.
>>
>> I looked at nouveau KMS driver and adapted the part for i915:
>>
>> drivers/gpu/drm/nouveau/nouveau_drm.c-200-      /* remove conflicting
>> drivers (vesafb, efifb etc) */
>> drivers/gpu/drm/nouveau/nouveau_drm.c:201:      aper = alloc_apertures(3);
>> drivers/gpu/drm/nouveau/nouveau_drm.c-202-      if (!aper)
>> drivers/gpu/drm/nouveau/nouveau_drm.c-203-              return -ENOMEM;
>>
>> Untested by me, feel free to test.
>>
>> Maybe some of the i915 and/or fb driver experts can comment on the problem.
>
> The structure array from alloc_apertures is just used for the PCI base
> address registers, so it's important here.
>
> I'll take a look at the efifb locking later.
>

You had a chance to look at this?

- Sedat -

> Thanks,
>   Daniel
> --
> Daniel J Blueman
