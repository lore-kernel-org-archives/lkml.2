Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1JXIg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:36:57 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:44654 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570Ab1JXIg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:36:56 -0400
Message-ID: <4EA523A8.5000300@profihost.ag>
Date: Mon, 24 Oct 2011 10:36:56 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: p.herz@profihost.ag, David Rientjes <rientjes@google.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
References: <4E9D53FF.7090609@profihost.ag> <m2ipnmz49x.fsf@firstfloor.org>			 <alpine.DEB.2.00.1110181848150.12850@chino.kir.corp.google.com>			 <4EA506B9.4030604@profihost.ag>	 <1319439819.2517.38.camel@edumazet-laptop>	 <4EA51210.9070209@profihost.ag>	 <1319443278.2381.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <4EA51F9B.7090806@profihost.ag> <1319444998.2381.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1319444998.2381.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.10.2011 10:29, schrieb Eric Dumazet:
> Le lundi 24 octobre 2011 à 10:19 +0200, Philipp Herz - Profihost AG a
> écrit :
>> Currently i can not provide any further information, 'cause server has
>> been restarted.
>>
>> What exactly are you looking for?
>
> A dmesg for 2.6.32 is OK, I look for :
>
> - memory layout (tg3 has workarounds for 4G crossing),
> - and exact tg3 chip, tg3 messages...

Here is a dmesg from 2.6.38 where this message also does not occur:
http://pastebin.com/raw.php?i=HjDEKVcp

Stefan
