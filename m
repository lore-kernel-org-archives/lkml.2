Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab1DNK1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:27:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46901 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab1DNK1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aHPaL13d8gTbz7T7ZFpN8vnTxHuHsWNxBzfWtrNNQehoKgirlG487gjFFZH6wkoMQY
         6zGQUP4eJgPddVcT2I3LvGjV3k0DPgynJwNv8xhfBjyEHrWoOWgbcFcciSsrigmfgnEm
         B1uOVKU98pOcGJRiP6f90RIR5Xq9yJD3rjQD4=
Subject: Re: Regression from 2.6.36
From: Eric Dumazet <eric.dumazet@gmail.com>
To: azurIt <azurit@pobox.sk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Changli Gao <xiaosuo@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20110414110816.EA841944@pobox.sk>
References: <20110315132527.130FB80018F1@mail1005.cent>
	 <20110317001519.GB18911@kroah.com> <20110407120112.E08DCA03@pobox.sk>
	 <4D9D8FAA.9080405@suse.cz>
	 <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>
	 <1302177428.3357.25.camel@edumazet-laptop>
	 <1302178426.3357.34.camel@edumazet-laptop>
	 <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
	 <1302190586.3357.45.camel@edumazet-laptop>
	 <20110412154906.70829d60.akpm@linux-foundation.org>
	 <BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>
	 <20110412183132.a854bffc.akpm@linux-foundation.org>
	 <1302662256.2811.27.camel@edumazet-laptop>
	 <20110413141600.28793661.akpm@linux-foundation.org>
	 <1302747058.3549.7.camel@edumazet-laptop>
	 <20110413222803.38e42baf.akpm@linux-foundation.org>
	 <1302762718.3549.229.camel@edumazet-laptop>
	 <20110414110816.EA841944@pobox.sk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 12:27:45 +0200
Message-ID: <1302776866.3248.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 14 avril 2011 à 11:08 +0200, azurIt a écrit :
> Here it is:
> 
> 
> # ls /proc/31416/fd | wc -l
> 5926

Hmm, if its a 32bit kernel, I am afraid Andrew patch wont solve the
problem...

[On 32bit kernel, we still use kmalloc() up to 8192 files ]


