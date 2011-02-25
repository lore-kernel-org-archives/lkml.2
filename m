Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1BYKwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:52:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39302 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab1BYKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:52:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XvHDrV12cLADD6xmnMlfEM79xu4ok+qxQIyetvpYMLCmLHtNDXqO/E1u+LBqtdcH07
         CoVgV8gzeCXEvBdQ+/cC3mmhfSvnIbs6bdxVNab5pnk9460QL2qlkZp38m6c5pt5dKXv
         01DXe+aKVrW7gMyjs927eN5PcUhQRt8aVbRT0=
Subject: Re: [PATCH ref0] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <AANLkTikmqQfT1s2Z6J+KYmqi0CuCc4+2k67eeb4ydtCM@mail.gmail.com>
References: <1298535761.2814.1.camel@edumazet-laptop>
	 <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
	 <1298569179.2814.11.camel@edumazet-laptop>
	 <1298569685.2814.16.camel@edumazet-laptop>
	 <AANLkTikXUyQy+fjFSwagB3Uud2JPodsR2yFtt+jiZPSk@mail.gmail.com>
	 <AANLkTikmqQfT1s2Z6J+KYmqi0CuCc4+2k67eeb4ydtCM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 11:52:07 +0100
Message-ID: <1298631127.2659.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 février 2011 à 17:45 +0800, Po-Yu Chuang a écrit :

> It's a little faster than v5 now. Thanks.
> I will submit the current version later.
> 
> One more question just curious, why 128 bytes?

Probably its best for NIU hardware specs

You could try 64, as it should be enough for most IP/TCP/UDP processing.



