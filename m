Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0CYKUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:20:05 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:24266 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0CYKUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:20:03 -0400
Message-ID: <4BAB38B1.8080404@ru.mvista.com>
Date: Thu, 25 Mar 2010 13:19:29 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       linux-arm-kernel@lists.infradead.org, linux-pcmcia@lists.infradead.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: pcmcia: fix checkpatch.pl issues in soc_common.c
References: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>	<1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <20100324230729.GA21359@n2100.arm.linux.org.uk>
In-Reply-To: <20100324230729.GA21359@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Russell King - ARM Linux wrote:

>> -	debug(skt, 2, "mask: %s%s%s%s%s%sflags: %s%s%s%s%s%sVcc %d Vpp %d irq %d\n",
>> -			(state->csc_mask==0)?"<NONE> ":"",
>> -			(state->csc_mask&SS_DETECT)?"DETECT ":"",
>> -			(state->csc_mask&SS_READY)?"READY ":"",
>> -			(state->csc_mask&SS_BATDEAD)?"BATDEAD ":"",
>> -			(state->csc_mask&SS_BATWARN)?"BATWARN ":"",
>> -			(state->csc_mask&SS_STSCHG)?"STSCHG ":"",
>> -			(state->flags==0)?"<NONE> ":"",
>> -			(state->flags&SS_PWR_AUTO)?"PWR_AUTO ":"",
>> -			(state->flags&SS_IOCARD)?"IOCARD ":"",
>> -			(state->flags&SS_RESET)?"RESET ":"",
>> -			(state->flags&SS_SPKR_ENA)?"SPKR_ENA ":"",
>> -			(state->flags&SS_OUTPUT_ENA)?"OUTPUT_ENA ":"",
>> +	debug(skt, 2,	"mask: %s%s%s%s%s%s "
>> +			"flags: %s%s%s%s%s%s Vcc %d Vpp %d irq %d\n",
>>     
>
> NAK.  Breaking kernel messages across multiple lines makes them impossible
> to grep for.  checkpatch.pl is wrong on this one.
>   

   I'd disagree in this case. Anybody will hardly grep for "mask: 
%s%s%s%s%s%sflags: %s%s%s%s%s%s".

WBR, Sergei

