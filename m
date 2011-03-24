Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934235Ab1CXWce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:32:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61502 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab1CXWcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LmjPv/DacCS1MyWxCZVqrgsINSTOWggj1v+oP8aLk0VzA9oPpXkK4+GZ5QgqkNWsx0
         5jTuEz6SYsLjITMw8jg95fZi3vuRNoWTbSQqpG9RgPheODOCL5c/+4e1Lxfed4c01+DA
         RlCIMk2mN8M+pnr1xToTi6iMQpmJ/xhqlK+vQ=
Subject: Re: [PATCH] ipv4: fix fib metrics
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTinv+XGBjbFoK6vpyiDW6gBEBKFjUef+mCAMJU9i@mail.gmail.com>
References: <AANLkTik6+TrjiC6ZF+KHhZ1iPzEe2jDayr363C0HgQN4@mail.gmail.com>
	 <1300980118.3747.42.camel@edumazet-laptop>
	 <AANLkTikZhT5LaA-UEXniDvkneH8JScaVaCaCd4LT59cV@mail.gmail.com>
	 <1300983340.3747.44.camel@edumazet-laptop>
	 <1300986084.3747.101.camel@edumazet-laptop>
	 <AANLkTik+Rf45wUxN86t+Zp7+AXjcJsy0vmZgvmLj-95x@mail.gmail.com>
	 <1300992308.3747.205.camel@edumazet-laptop>
	 <AANLkTin_gxMF1hyK_yhN+G9UGfcBKAhPE24r7tLe5j3D@mail.gmail.com>
	 <1301005107.2714.113.camel@edumazet-laptop>
	 <AANLkTinv+XGBjbFoK6vpyiDW6gBEBKFjUef+mCAMJU9i@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 23:32:26 +0100
Message-ID: <1301005946.2714.130.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 23:27 +0100, Alessandro Suardi a écrit :

> Don't think so. This tool has been working since I built it (29 June 2010)
>  and still works in -git2 :)
> 

Then it doesnt work anymore because it parses an ipip field from
ip route get ...

$ ip ro get 192.168.1.1
192.168.1.1 dev wlan0  src 192.168.1.21 
    cache  ipid 0x784c mtu 1500 advmss 1460 hoplimit 64


Maybe you upgraded iproute2



