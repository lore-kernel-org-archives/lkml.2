Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1BRNaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 08:30:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33021 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab1BRNaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:30:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OIQg/2JxG4NrCkJalkx29m/VjllfUN8O7AKRzoy1L+RdUed9mufKy307ud9nncjEkO
         uzHym1ztgmio8IL8qqSECxcwNDN75ixM1F7xBhSt5F3zlu+IZwa2fevJRyeleYrMonq+
         NjYxFOIWu2BJv68ZwbhLsdqNKzbNgu/z+ImhU=
MIME-Version: 1.0
In-Reply-To: <1298035443.6201.51.camel@edumazet-laptop>
References: <20110218050321.10415.qmail@science.horizon.com>
 <1298010735.2642.9.camel@edumazet-laptop> <1298023023.2595.170.camel@edumazet-laptop>
 <AANLkTi=GRPWNWZuORx1zoJJURE-drqEoMdTuKB9LZ8Ux@mail.gmail.com> <1298035443.6201.51.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 18 Feb 2011 21:29:43 +0800
Message-ID: <AANLkTi=O1LZzSc8=qMX=R3rJpCVL8eWr1eo6NkiZXS0m@mail.gmail.com>
Subject: Re: [PATCH] net: Add default_advmss() methods to blackhole dst_ops
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: George Spelvin <linux@horizon.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 9:24 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 18 février 2011 à 21:16 +0800, Changli Gao a écrit :
>
>> I am wondering why magic number 256 is used here. Is there a special
>> reason? Thanks.
>>
>
> It really doesnt matter. SYN message will be dropped anyway.
>
> 256 happens to be the default value
> of /proc/sys/net/ipv4/route/min_adv_mss
>

Thanks for your explaining. IMHO, ip_rt_min_advmss is better than a
magic number, here.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
