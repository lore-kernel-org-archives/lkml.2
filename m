Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab1DNKby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:31:54 -0400
Received: from gmmr5.centrum.cz ([90.183.38.152]:46556 "EHLO gmmr5.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726Ab1DNKbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:31:52 -0400
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Subject: Re: Regression from 2.6.36
Date: Thu, 14 Apr 2011 12:31:50 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Changli Gao" <xiaosuo@gmail.com>,
        "=?UTF-8?Q?Am=C3=A9rico=20Wang?=" <xiyou.wangcong@gmail.com>,
        "Jiri Slaby" <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        "Jiri Slaby" <jirislaby@gmail.com>, "Mel Gorman" <mel@csn.ul.ie>
References: <20110315132527.130FB80018F1@mail1005.cent>	 <20110317001519.GB18911@kroah.com> <20110407120112.E08DCA03@pobox.sk>	 <4D9D8FAA.9080405@suse.cz>	 <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>	 <1302177428.3357.25.camel@edumazet-laptop>	 <1302178426.3357.34.camel@edumazet-laptop>	 <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>	 <1302190586.3357.45.camel@edumazet-laptop>	 <20110412154906.70829d60.akpm@linux-foundation.org>	 <BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>	 <20110412183132.a854bffc.akpm@linux-foundation.org>	 <1302662256.2811.27.camel@edumazet-laptop>	 <20110413141600.28793661.akpm@linux-foundation.org>	 <1302747058.3549.7.camel@edumazet-laptop>	 <20110413222803.38e42baf.akpm@linux-foundation.org>	 <1302762718.3549.229.camel@edumazet-laptop>	 <20110414110816.EA841944@pobox.sk> <1302776866.3248.2.camel@edumazet-laptop>
In-Reply-To: <1302776866.3248.2.camel@edumazet-laptop>
X-Mailer: Centrum Email 5.3
X-Priority: 3
MIME-Version: 1.0
Message-Id: <20110414123150.F96CAA51@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's completely 64bit system.



______________________________________________________________
> Od: "Eric Dumazet" <eric.dumazet@gmail.com>
> Komu: azurIt <azurit@pobox.sk>
> Dátum: 14.04.2011 12:28
> Predmet: Re: Regression from 2.6.36
>
> CC: "Andrew Morton" <akpm@linux-foundation.org>, "Changli Gao" <xiaosuo@gmail.com>, "Américo Wang" <xiyou.wangcong@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>, "Mel Gorman" <mel@csn.ul.ie>
>Le jeudi 14 avril 2011 à 11:08 +0200, azurIt a écrit :
>> Here it is:
>> 
>> 
>> # ls /proc/31416/fd | wc -l
>> 5926
>
>Hmm, if its a 32bit kernel, I am afraid Andrew patch wont solve the
>problem...
>
>[On 32bit kernel, we still use kmalloc() up to 8192 files ]
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
