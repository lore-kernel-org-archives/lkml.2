Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1FCM1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:27:03 -0400
Received: from mail202c2.megamailservers.com ([69.49.111.103]:43481 "EHLO
	mail202c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191Ab1FCM1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:27:01 -0400
X-Authenticated-User: daniel.gaisler.com
Message-ID: <4DE8D303.1080706@gaisler.com>
Date: Fri, 03 Jun 2011 14:26:43 +0200
From: Daniel Hellstrom <daniel@gaisler.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (sparc-current
 tree related)
References: <20110603135347.a17e0b85.sfr@canb.auug.org.au>	<20110602.222051.270790327969020201.davem@davemloft.net>	<4DE8906F.5040501@gaisler.com> <20110603.011455.414200582548238157.davem@davemloft.net>
In-Reply-To: <20110603.011455.414200582548238157.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=xbudj22Aknmj7PWPRHa2OUfQBaxQEGnZbHIINz1otWI= c=1 sm=1
		a=pl2ZPvC6udcA:10 a=5CtTeIlDWD8A:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=ebG-ZW-8AAAA:8 a=TfZMrI_yVTnUjnJtDRkA:9
		a=wPNLvfGTeEIA:10 a=cCYF7-FHeg4A:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

>From: Daniel Hellstrom <daniel@gaisler.com>
>Date: Fri, 03 Jun 2011 09:42:39 +0200
>
>  
>
>>missed that, PCIC_PCI should depend on SPARC32_PCI instead of PCI in
>>the following lines that were added by the patch
>>
>>+config PCIC_PCI
>>+	bool
>>+	depends on PCI && !SPARC_LEON
>>+	default y
>>+
>>    
>>
>
>The fixed I pushed out used PCI && SPARC32 && !SPARC_LEON
>  
>
Ok, the same thing, thanks.

