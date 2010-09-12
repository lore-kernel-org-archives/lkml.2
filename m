Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0ILN4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 09:56:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61513 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0ILN4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 09:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xO22fYuxMYVtuMjffdH7OlCFn/oahnfMAxfngM6jbVYA/Gg/BS9zu8OANjMJEyroKF
         NxnMEZHb2Yvj1Ll0NjEy4yTuxdRPrdrt86N1QNh+WaaG/EFaZ3nrgOiEJBt4GxWW1a1m
         YkqvVEKpSr5C+DRaRdvpZlbrj2LYC92XJUz+U=
MIME-Version: 1.0
In-Reply-To: <20100912122955.GA28839@cmpxchg.org>
References: <1284289340.2650.2.camel@ht.satnam>
	<20100912122955.GA28839@cmpxchg.org>
Date: Sun, 12 Sep 2010 19:26:10 +0530
Message-ID: <AANLkTinPWd2bavC_44WkEL++KXirZ1CW3dTNK7G-Oag=@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: Remove useless condition
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 12, 2010 at 5:59 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Sun, Sep 12, 2010 at 04:32:20PM +0530, Jaswinder Singh Rajput wrote:
>>
>> if (ret) is useless as it will be never NULL as in previous statement
>> we are setting ret = prev for !ret
>
> If there is no match and no extent below the given file offset, `prev'
> will be NULL as well, no?
>
> So the check is not useless, it prevents throwing out a cached success
> in case of a lookup failure.
>

Got it !!

Thanks,
--
Jaswinder Singh.
