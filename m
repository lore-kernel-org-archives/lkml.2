Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1ANGuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 01:50:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50331 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1ANGuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 01:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wFBygaK1ocFijtty5Gz5C4DeQDNy39nWtU4fzJYs6ceJYmBTGfTzjc6Hv5ZFcrxPAU
         CHpf7VAd8iBjr2vlgydvg9Pw2EuTh3/F3oBMg9gg7jqBBQhFAKMaAgb357k7bn3neM6G
         PgUTq8YITO47PN6514/L6m7DllCXuagoMd1+c=
MIME-Version: 1.0
In-Reply-To: <1294959948.4114.189.camel@Joe-Laptop>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com> <1294959948.4114.189.camel@Joe-Laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 14 Jan 2011 14:49:45 +0800
Message-ID: <AANLkTikP1T9XXPVNHnmPnamjwyF5nNn+hVvpovAxTx69@mail.gmail.com>
Subject: Re: [PATCH] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Joe,

On Fri, Jan 14, 2011 at 7:05 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2011-01-13 at 19:49 +0800, Po-Yu Chuang wrote:
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> []
>> +     if (is_zero_ether_addr(netdev->dev_addr)) {
>> +             random_ether_addr(netdev->dev_addr);
>> +             dev_info(&netdev->dev, "generated random MAC address "
>> +                     "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x.\n",
>> +                     netdev->dev_addr[0], netdev->dev_addr[1],
>> +                     netdev->dev_addr[2], netdev->dev_addr[3],
>> +                     netdev->dev_addr[4], netdev->dev_addr[5]);
>
> Sorry, one other thing.
> There are kernel specific printf extensions for pointer types.
> (look at lib/vsprintf.c)  There's one for mac addresses: "%pM".
> This could be done as:
>
>                netdev_info(netdev, "Generated random MAC address: %pM\n",
>                            netdev->dev_addr);

Wow, this is pretty beautiful. Thanks.

best regards,
Po-Yu Chuang
