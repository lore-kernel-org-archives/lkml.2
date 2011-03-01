Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1CAFwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:52:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36442 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab1CAFwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:52:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VzVrivqSVWSCXVWyQfW2CwC8ayLMvxxquKFYg6tlvXK4Zxn9BF1Dykls4LKEaj5ZFf
         NcJ5K4iqCqQXP5j9PpZFIn95AOaJsu1kCHSsD7RkaM9txOm1NRkWMSe4MNqQmA3CohDb
         2owaLmK/4fmTJQk/1i88XajCCd4BqrTY8UJ7E=
MIME-Version: 1.0
In-Reply-To: <1298958336.2676.21.camel@edumazet-laptop>
References: <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
 <1298627845-1583-1-git-send-email-ratbert.chuang@gmail.com>
 <1298634040.2659.32.camel@edumazet-laptop> <AANLkTimeDR27Q7fcBmB0ix7Q_pRT_GDpc7S3LO21-fh-@mail.gmail.com>
 <1298958336.2676.21.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Tue, 1 Mar 2011 13:51:42 +0800
Message-ID: <AANLkTi=Sp-mAV1556pZvCvHzQ=MQNHUzjo0ap2DhKwWe@mail.gmail.com>
Subject: Re: [PATCH v6] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Tue, Mar 1, 2011 at 1:45 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 01 mars 2011 à 13:20 +0800, Po-Yu Chuang a écrit :
>
>> That means, since every rx buffer is large enough, it is impossible to
>> get a multi-segment packets.
>>
>> So I simplified ftmac100_rx_packet().
>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Ah, I just want to submit a v7.
Could you resign again later, please? :-)

> I am only wondering then if not using fragments would be faster then
> (eventually doing copybreaks for small frames like tg3)

Although not many circumstances are tested.
iperf shows that it is a little faster to use fragments than memcpy, so...

> But if you plan to get new hw soon, you have the infrastructure...

best regards,
Po-Yu Chuang
