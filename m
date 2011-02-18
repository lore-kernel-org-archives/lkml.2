Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab1BRNno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 08:43:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39761 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1BRNnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:43:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bVH5xzXRyKWG8jKUyfWFJKsfZawGnpUlHxttfpmuWjuLMwnR84kCm/9sHlJgmtpvu0
         cQqykr3D5sDy4QUYmlyqINrWKYddmwU+cV+xA0TQ/HZYG+nlMCf8OKC8aHRRYvBf6ZjB
         fciJwFWZEn0PzFWikLqPpq7Qn7wSccNOwdH4Q=
MIME-Version: 1.0
In-Reply-To: <1298036005.6201.58.camel@edumazet-laptop>
References: <20110218050321.10415.qmail@science.horizon.com>
	<1298010735.2642.9.camel@edumazet-laptop>
	<1298023023.2595.170.camel@edumazet-laptop>
	<AANLkTi=GRPWNWZuORx1zoJJURE-drqEoMdTuKB9LZ8Ux@mail.gmail.com>
	<1298035443.6201.51.camel@edumazet-laptop>
	<AANLkTi=O1LZzSc8=qMX=R3rJpCVL8eWr1eo6NkiZXS0m@mail.gmail.com>
	<1298036005.6201.58.camel@edumazet-laptop>
Date: Fri, 18 Feb 2011 15:43:37 +0200
X-Google-Sender-Auth: bnHDCiVg8K7aPPLxniSQbNwU9WY
Message-ID: <AANLkTi=8FXbL+Sew8EbE4uEvVXO=gNaWsRv-0RiO0JMj@mail.gmail.com>
Subject: Re: [PATCH] net: Add default_advmss() methods to blackhole dst_ops
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Changli Gao <xiaosuo@gmail.com>, George Spelvin <linux@horizon.com>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 3:33 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 18 février 2011 à 21:29 +0800, Changli Gao a écrit :
>> On Fri, Feb 18, 2011 at 9:24 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> > Le vendredi 18 février 2011 à 21:16 +0800, Changli Gao a écrit :
>> >
>> >> I am wondering why magic number 256 is used here. Is there a special
>> >> reason? Thanks.
>> >>
>> >
>> > It really doesnt matter. SYN message will be dropped anyway.
>> >
>> > 256 happens to be the default value
>> > of /proc/sys/net/ipv4/route/min_adv_mss

Perhaps a comment would make sense then.

thanks,
Daniel.
