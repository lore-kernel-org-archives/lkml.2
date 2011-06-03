Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab1FCHm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 03:42:56 -0400
Received: from mail168c2.megamailservers.com ([69.49.111.68]:49833 "EHLO
	mail168c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637Ab1FCHmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 03:42:55 -0400
X-Authenticated-User: daniel.gaisler.com
Message-ID: <4DE8906F.5040501@gaisler.com>
Date: Fri, 03 Jun 2011 09:42:39 +0200
From: Daniel Hellstrom <daniel@gaisler.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (sparc-current
 tree related)
References: <20110603135347.a17e0b85.sfr@canb.auug.org.au> <20110602.222051.270790327969020201.davem@davemloft.net>
In-Reply-To: <20110602.222051.270790327969020201.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=WwssvlT0cz5J1BoOJvKjEQtles6kVRNS28LycuPzbaY= c=1 sm=1
		a=pl2ZPvC6udcA:10 a=5CtTeIlDWD8A:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=rOUgymgbAAAA:8 a=F7lMu4zxE0NYX6z6DLUA:9
		a=wPNLvfGTeEIA:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

>From: Stephen Rothwell <sfr@canb.auug.org.au>
>Date: Fri, 3 Jun 2011 13:53:47 +1000
>
>  
>
>>Caused by commit cfe3af5dde34 ("sparc32: added CONFIG_PCIC_PCI Kconfig
>>setting") from the sparc-current tree.
>>
>>I have reverted that commit (and the 2 following commits that depend on
>>it) for today.
>>    
>>
>
>Oops, that needs a sparc32 depencency.  I'll fix that, thanks!
>  
>
missed that, PCIC_PCI should depend on SPARC32_PCI instead of PCI in the 
following lines that were added by the patch

+config PCIC_PCI
+	bool
+	depends on PCI && !SPARC_LEON
+	default y
+



