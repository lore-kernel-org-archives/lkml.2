Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab1ENOpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 10:45:42 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50176 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab1ENOpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 10:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jWuoyU9RDNFh6OkQj6+C93luVNtgf1przmO0x3ct2MEUVeqclfeipfE3nvMV3jMptW
         32QP1tEHRp134RI/VEw6Y9J/88n/pSPj2JsDTZ0d2SXXcBSXMI0hf+rOPMqY7NV6bfv+
         fzp9/jzNEj4qqkm7sjv3UW5CRlbYNtlSDYQrk=
MIME-Version: 1.0
In-Reply-To: <1305383610.3120.62.camel@edumazet-laptop>
References: <20110514134307.GA3603@maxin>
	<1305383610.3120.62.camel@edumazet-laptop>
Date: Sat, 14 May 2011 17:45:39 +0300
Message-ID: <BANLkTikeeBdFrnPX7J=uRswFZm-mwUxh=w@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: mcast: Removing invalid check
From: Maxin B John <maxin.john@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        yoshfuji@linux-ipv6.org, jmorris@namei.org, pekkas@netcore.fi,
        kuznet@ms2.inr.ac.ru, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> At a first glance, I would say Coverity is wrong, unless you can explain
> why it's right ;)
>
> first can be 0 at this point, we are in a loop.

You are right.

> BTW "Removing invalid check" is a really wrong patch title.
>
> Once you can prove your point, you should use "Remove useless check"
>

I will keep it in mind. Thanks .

Best Regards,
Maxin B John
