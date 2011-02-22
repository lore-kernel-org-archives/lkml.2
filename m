Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1BVNTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:19:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50585 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1BVNTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:19:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=YFPzSc7Iz15ZoaPQZh38fO6DP8d8XfN92jhc0w3tYMtp/MT/x3IFOToB/Xs151316j
         4tr4VoxrJrQtk8q1ptyrqXAUUDh8+Uh+7Oh2VWQyOdGhD+1MXpPXeaKXKul62sMWUtXy
         vq7zXSCoqdwLimRuIOU7d4zbsUoG4MDnf2Xc4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikTHnz+7C-QmXaHwFE0a+pw7U-t2JP11a0qdoyU@mail.gmail.com>
References: <1297786849.2596.13.camel@phoenix> <4D5AB09C.9000106@compulab.co.il>
 <AANLkTino2vLisNgKeyXppuHwDyhLMMAcOOZjA0hgmkj6@mail.gmail.com>
 <4D637557.2070707@compulab.co.il> <AANLkTikTHnz+7C-QmXaHwFE0a+pw7U-t2JP11a0qdoyU@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 22 Feb 2011 21:19:01 +0800
Message-ID: <AANLkTin7E9j6Q32JR-t13ekpdveiSrPCqAorT08DdM=6@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: support 806MHz operating points for PXA31x
 processors A2 stepping
To: Axel Lin <axel.lin@gmail.com>, Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Another thing (which could be related to the patch) is the package marking.
>> We have PXA3xx SoCs marked A2 stepping, but C624, which means that the
>> highest running frequency should not exceed 624MHz.
>
> This means not all PXA310 A2 stepping supports 806Mhz.
> Can we differentiate the Cxxx option in software?
>
>> What is your PXA3xx A2 marking in respect to Cxxx option?
>
> Mine is 88AP310-A2-BGK2C806.
>

Haojian,

Can you help check on the stepping/markings on these processors
to see which of them supports 806MHz, reliably?

- eric
