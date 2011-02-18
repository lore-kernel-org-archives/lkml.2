Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1BRNYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 08:24:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64434 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1BRNYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:24:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uN9LKat/4sjG2xNonFZ9e6KvZy82VKNLz7efQk91MOfYFMTbSUy5novXhz+sOiIE7p
         8+HS0i3sHejnYUYNmkKCJXWB+Un0Pir24elqW7eoHCMYBaLOC4NP0Mao7dmfC8RbQlIk
         2uZXeq/iW6VVZm5pGZh49PGXe9Cid5cdUiJ88=
Subject: Re: [PATCH] net: Add default_advmss() methods to blackhole dst_ops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: George Spelvin <linux@horizon.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>
In-Reply-To: <AANLkTi=GRPWNWZuORx1zoJJURE-drqEoMdTuKB9LZ8Ux@mail.gmail.com>
References: <20110218050321.10415.qmail@science.horizon.com>
	 <1298010735.2642.9.camel@edumazet-laptop>
	 <1298023023.2595.170.camel@edumazet-laptop>
	 <AANLkTi=GRPWNWZuORx1zoJJURE-drqEoMdTuKB9LZ8Ux@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 14:24:03 +0100
Message-ID: <1298035443.6201.51.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 18 février 2011 à 21:16 +0800, Changli Gao a écrit :

> I am wondering why magic number 256 is used here. Is there a special
> reason? Thanks.
> 

It really doesnt matter. SYN message will be dropped anyway.

256 happens to be the default value
of /proc/sys/net/ipv4/route/min_adv_mss



