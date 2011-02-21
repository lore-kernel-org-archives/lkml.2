Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab1BULkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 06:40:03 -0500
Received: from mail-ew0-f42.google.com ([209.85.215.42]:47075 "EHLO
	mail-ew0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab1BULkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 06:40:00 -0500
Message-ID: <4D624EBD.4080400@ru.mvista.com>
Date: Mon, 21 Feb 2011 14:38:37 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] ata_piix: unify code for programming PIO and MWDMA
 timings
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>	<20110208122346.19110.8441.sendpatchset@linux-mhg7.site>	<4D6118DC.80505@ru.mvista.com>	<20110220185958.364df4cc@lxorguk.ukuu.org.uk>	<4D617CC8.3020108@ru.mvista.com> <20110220210731.0c774fa7@lxorguk.ukuu.org.uk>
In-Reply-To: <20110220210731.0c774fa7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-02-2011 0:07, Alan Cox wrote:

>>      PIO mode is setup by different code, and it takes care of the IORDY
>> setting according to the PIO rules (and it gets called). DMA mode setup should
>> just ignore the IORDY setting as in all other sane drivers.

> Well it can't ignore it - but if you mean just keep the bit as is then

    Yes, I mean this.

> that sounds sensible, have to see what the docs say happens if you ever
> set MWDMA without IORDY.

    Don't think they say anything on this matter but I can't imagine that 
IORDY matters for DMA.

WBR, Sergei
