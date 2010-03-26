Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0CZA7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 20:59:16 -0400
Received: from server78.greatnet.de ([83.133.96.102]:36304 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab0CZA7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 20:59:15 -0400
Message-ID: <4BAC06DB.70800@nachtwindheim.de>
Date: Fri, 26 Mar 2010 01:59:07 +0100
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: isdn@linux-pingi.de, linux@dominikbrodowski.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] isdn: Cleanup Sections in PCMCIA driver sedlbauer
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>	<201003251313.18144.isdn@linux-pingi.de> <20100325.115846.00009969.davem@davemloft.net>
In-Reply-To: <20100325.115846.00009969.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller schrieb:
> From: Karsten Keil <isdn@linux-pingi.de>
> Date: Thu, 25 Mar 2010 13:13:18 +0100
>
>   
>> On Donnerstag, 25. März 2010 13:05:29 Henrik Kretzschmar wrote:
>>     
>>> Compiling this driver gave a section mismatch,
>>> so I reviewed the init/exit paths of the driver
>>> and made the correct changes.
>>>
>>> WARNING: drivers/isdn/hisax/built-in.o(.text+0x558d6): Section mismatch
>>> in reference from the function sedlbauer_config() to the function
>>> .devinit.text:hisax_init_pcmcia()
>>> The function sedlbauer_config() references
>>> the function __devinit hisax_init_pcmcia().
>>> This is often because sedlbauer_config lacks a __devinit
>>> annotation or the annotation of hisax_init_pcmcia is wrong.
>>>
>>> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
>>>       
>> Acked-by: <keil@b1-systems.de>
>>
>> Thank you for fixing this.
>>     
>
> Thanks for reviewing Karsten.
>
> Please put your proper name in your ACK lines in the
> future, they should look just like Signed-off-by: lines.
>
> I fixed this up when committing, thanks again.
>
>   
Hi David,

I've seen that you put the patches on the net-tree. Thats fine.
In the author field my real name "Henrik Kretzschmar" was replaced by "Henne" somehow.
That's not a problem for me, but I just wanted to have you noticed about that.

Greets Henrik

P.S. cc-ing to netdev is okay.


