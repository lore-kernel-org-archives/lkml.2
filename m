Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1AYCqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 21:46:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1AYCqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 21:46:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TS5p0jE4/ITywv0uCKhS0gui1XeZgb4imUkfQJq0Z3AotUivPPVJkXlremGRxVqiQn
         EfhybV6U+8HoT6yVFTJu6RoyoM1Ky17VMmAoK89AyPoKeP5VQfF7AE5JKF/tp7aXbhmx
         jcyPCSnr7qqp9RJE3loWr14Ny3BswHyAPhsEE=
MIME-Version: 1.0
In-Reply-To: <1295881662.2755.34.camel@edumazet-laptop>
References: <1295596533-1748-1-git-send-email-ratbert.chuang@gmail.com>
 <1295872799-1637-1-git-send-email-ratbert.chuang@gmail.com> <1295881662.2755.34.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Tue, 25 Jan 2011 10:46:18 +0800
Message-ID: <AANLkTinedmQKBn0rEwE=tYfj37f6uXt3rFNp+xVPcwZm@mail.gmail.com>
Subject: Re: [PATCH v5] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eric,

On Mon, Jan 24, 2011 at 11:07 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le lundi 24 janvier 2011 à 20:39 +0800, Po-Yu Chuang a écrit :
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>> +
>> +     priv->tx_pending++;
>> +     if (priv->tx_pending == TX_QUEUE_ENTRIES) {
>> +             if (net_ratelimit())
>> +                     netdev_info(netdev, "tx queue full\n");
>
> Hmm, I guess you didnt tested your driver with a pktgen flood ;)
>
> This 'netdev_info(netdev, "tx queue full\n");' is not necessary, since
> its a pretty normal condition for a driver (to fill its TX ring buffer)

Errr... No, I didn't test it with pktgen. I tested it with normal NFS usages.
I'll try it.

best regards,
Po-Yu Chuang
