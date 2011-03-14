Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1CNKww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:52:52 -0400
Received: from smtp-tls2.univ-nantes.fr ([193.52.101.146]:37803 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1CNKwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:52:49 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Mar 2011 06:52:49 EDT
Message-ID: <4D7DF1A3.6020501@univ-nantes.fr>
Date: Mon, 14 Mar 2011 11:44:51 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15pre) Gecko/20110207 Shredder/3.1.9pre
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: kernel 2.6.37 : oops in cleanup_once
References: <4D491B8D.1000107@univ-nantes.fr>	 <1296643972.20445.9.camel@edumazet-laptop>	 <1296645887.20445.11.camel@edumazet-laptop>	 <4D495765.4090806@univ-nantes.fr>	 <1296658407.20445.19.camel@edumazet-laptop>	 <4D49726C.6020103@univ-nantes.fr> <1296659336.20445.22.camel@edumazet-laptop>
In-Reply-To: <1296659336.20445.22.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/02/2011 16:08, Eric Dumazet a écrit :


> I suspect a mem corruption from another layer (not inetpeer)
>
> Unfortunately many kmem caches share the "64 bytes" cache.
>
> Could you please add "slub_nomerge" on your boot command ?
>
...

>
>> -Is there a very severe impact on performance ?
>>
> not at all
>
Maybe there is an impact after all : since then, we don't have problems 
anymore !

linkwood:~# uptime
  11:42:03 up 39 days, 17:08,  3 users,  load average: 0.01, 0.03, 0.05

So... could slub_nomerge hide or simply avoid the problem ?
Or are we just lucky this time ?


-- 
Yann Dupont - Service IRTS, DSI Université de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

