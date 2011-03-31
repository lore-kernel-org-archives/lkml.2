Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab1CaQia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:38:30 -0400
Received: from mail176c2.megamailservers.com ([69.49.111.76]:51575 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757995Ab1CaQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:38:27 -0400
X-Greylist: delayed 10270 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 12:38:26 EDT
X-Authenticated-User: daniel.gaisler.com
Message-ID: <4D9485B3.5060306@gaisler.com>
Date: Thu, 31 Mar 2011 15:46:27 +0200
From: Daniel Hellstrom <daniel@gaisler.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (sparc-current
 tree related)
References: <20110331130127.1d60ba11.sfr@canb.auug.org.au> <20110330.211044.212408233.davem@davemloft.net>
In-Reply-To: <20110330.211044.212408233.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=7GFoO/wu22Xu7f+7cd9V9wY/biOPJIupRAMVre9JRXg= c=1 sm=1
		a=pl2ZPvC6udcA:10 a=5CtTeIlDWD8A:10 a=8nJEP1OIZ-IA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=rOUgymgbAAAA:8 a=Arj1MxDfYlZM8WROh4IA:9
		a=wPNLvfGTeEIA:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

>From: Stephen Rothwell <sfr@canb.auug.org.au>
>Date: Thu, 31 Mar 2011 13:01:27 +1100
>
>  
>
>>Hi all,
>>
>>After merging the final tree, today's linux-next build (powerpc
>>allyesconfig) failed like this:
>>
>>drivers/tty/serial/apbuart.c: In function 'apbuart_probe':
>>drivers/tty/serial/apbuart.c:568: error: 'struct pdev_archdata' has no member named 'irqs'
>>
>>Caused by commit 10544f128c33 ("sparc32, leon: APBUART driver must use
>>archdata to get IRQ number").
>>
>>I have reverted that commit for today (and commit c897dcf6311e
>>"sparc32,leon: Fixed APBUART frequency detection" that conflicts with the
>>revert).
>>    
>>
>
>Thanks, I'll make apbuart depend upon sparc to fix this.
>  
>
Thanks all.


