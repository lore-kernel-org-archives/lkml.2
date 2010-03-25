Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0CYOIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:08:47 -0400
Received: from server78.greatnet.de ([83.133.96.102]:33442 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0CYOIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:08:45 -0400
Message-ID: <4BAB6E65.7@nachtwindheim.de>
Date: Thu, 25 Mar 2010 15:08:37 +0100
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: isdn@linux-pingi.de, davem@davemloft.net, linux@dominikbrodowski.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] isdn: Cleanup Sections in PCMCIA driver sedlbauer
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de> <20100325121610.GB5069@pengutronix.de>
In-Reply-To: <20100325121610.GB5069@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang schrieb:

> Hi Henrik,
>
> thanks for the work. Please, just keep the placement of those attributes
> consistent. Otherwise it might be easy to miss:
>
>   
>> -static int sedlbauer_config(struct pcmcia_device *link);
>> +static int sedlbauer_config(struct pcmcia_device *link) __devinit ;
>>     
>
> Wrong.
>
>   
>> -static int sedlbauer_probe(struct pcmcia_device *link)
>> +static int __devinit sedlbauer_probe(struct pcmcia_device *link)
>>  {
>>     
>
> Right.
>
> (I think checkpatch checks for this, too)
No, checkpatch doesn't claim about that.

Greets, Henrik

