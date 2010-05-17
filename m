Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0EQGoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:44:13 -0400
Received: from mail175c2.megamailservers.com ([69.49.111.75]:55937 "EHLO
	mail175c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163Ab0EQGoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:44:11 -0400
X-Authenticated-User: kristoffer.gaisler.com
Message-ID: <4BF0E422.1070609@gaisler.com>
Date: Mon, 17 May 2010 08:37:22 +0200
From: Kristoffer Glembo <kristoffer@gaisler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070601 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
       David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: apbuart: Let boards without apbuart boot
References: <20100514141949.GA9244@oksana.dev.rtsoft.ru>	 <AANLkTikivSaAB9PehMYoqr5rpDOyScFPb9FI4tB9W14c@mail.gmail.com>	 <20100516102038.GA24271@oksana.dev.rtsoft.ru> <AANLkTim45g4ItOZKrysN1036vQgf10gVIzzuO30n_Gng@mail.gmail.com>
In-Reply-To: <AANLkTim45g4ItOZKrysN1036vQgf10gVIzzuO30n_Gng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CHA: v=1.1 cv=nfV7DS5/VNjzlYjkqXMAjlC4PTaANdlvmbFYHgeV1+I= c=1 sm=1
		a=v7eWIyTFRIIA:10 a=UBIxAjGgU1YA:10 a=8nJEP1OIZ-IA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=pGLkceISAAAA:8 a=fk1lIlRQAAAA:8
		a=ntG8zlgpFSdZbdrTMh8A:9 a=weaKOJVbhOIeYV6mY3XX4ngdrHQA:4 a=wPNLvfGTeEIA:10
		a=MSl-tDqOz04A:10 a=gH_wm7_JyAQA:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Miguel Ojeda wrote:
> On Sun, May 16, 2010 at 12:20 PM, Anton Vorontsov
> <cbouatmailru@gmail.com> wrote:
>> On Sun, May 16, 2010 at 10:41:50AM +0200, Miguel Ojeda wrote:
>>> On Fri, May 14, 2010 at 4:19 PM, Anton Vorontsov <avorontsov@mvista.com> wrote:
>>>> This patch fixes the following oops:
>>>>
>>> I sent a patch that fixes that oops too. It is in mm right now. Please check it.
>> Hm, and my patch is in Greg's tree already...
> 
> Well, that's weird... Andrew sent an email to Greg 4 days ago with the
> patch after Kristoffer ack'ed it. Maybe Greg missed it.
> 
>> Greg, if it didn't make it anywhere further your tree, please
>> drop it in favour of Miguel's patch, Miguel was the first who
>> sent a fix for this problem.
>>
> 
> Thanks, but Kristoffer should review your patch too, as they are not
> exactly the same: My patch changes does an additional check at
> grlib_apbuart_init() (which also calls grlib_apbuart_configure()),
> sets the global variable grlib_apbuart_port_nr to 0 and prints a
> message to the user; keeping the void return type of
> grlib_apbuart_configure().


Let's run with Miguels patch as it fixes the calls to grlib_apbuart_configure()
from both grlib_apbuart_init() and apbuart_console_init().

So Greg could you please drop Anton patch?

Anton if you want to please send a new patch annotating grlib_apbuart_configure
with __init though.

Best regards,
Kristoffer Glembo
Aeroflex Gaisler

 
