Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1JXITn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:19:43 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:51774 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571Ab1JXITm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:19:42 -0400
Message-ID: <4EA51F9B.7090806@profihost.ag>
Date: Mon, 24 Oct 2011 10:19:39 +0200
From: Philipp Herz - Profihost AG <p.herz@profihost.ag>
Reply-To: p.herz@profihost.ag
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        s.priebe@profihost.ag, linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
References: <4E9D53FF.7090609@profihost.ag> <m2ipnmz49x.fsf@firstfloor.org>		 <alpine.DEB.2.00.1110181848150.12850@chino.kir.corp.google.com>		 <4EA506B9.4030604@profihost.ag> <1319439819.2517.38.camel@edumazet-laptop>	 <4EA51210.9070209@profihost.ag> <1319443278.2381.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1319443278.2381.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-User-Auth: Auth by p.herz@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.10.2011 10:01, schrieb Eric Dumazet:
> Le lundi 24 octobre 2011 à 09:21 +0200, Philipp Herz - Profihost AG a
> écrit :
>
>> does that mean that there was no firmware limitation with kernel 2.6.32
>> or that the tg3 module has any "disable warnings" flag matching
>> __GFP_NOWARN?
>>
>
> There is no __GFP_NOWARN trick on tg3.
>
> We tend to prefer to be notified of a memory problem, instead of
> hide ...
yes,
that's exactly what would like to understand in comparison to the 
behavior of kernel 2.6.32.

why does this notification show up now and never did before...

>
> By the way, apparently this driver drops the frame and doesnt increase
> tx_dropped device counter. A patch will follow.
fine

>
> Could you post your full dmesg ?
>
>
Currently i can not provide any further information, 'cause server has 
been restarted.

What exactly are you looking for?
