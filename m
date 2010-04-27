Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab0D0PeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:34:10 -0400
Received: from mail.atmel.fr ([81.80.104.162]:56516 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab0D0PeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:34:08 -0400
Message-ID: <4BD703E8.4080307@atmel.com>
Date: Tue, 27 Apr 2010 17:34:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.infradead.org,
       akpm@linux-foundation.org, linux-mmc@vger.kernel.org,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] MMC: atmel-mci: fix two parameters swapped
References: <1271671952-29204-1-git-send-email-nicolas.ferre@atmel.com> <bfa27c51250b39deeccbf6f3a656db4e0b73ce92.1272378853.git.nicolas.ferre@atmel.com> <4BD70251.9060501@ru.mvista.com>
In-Reply-To: <4BD70251.9060501@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 27/04/2010 17:27, Sergei Shtylyov :
> Hello.
> 
> Nicolas Ferre wrote:
> 
>> Two parameters were swapped in the calls to atmci_init_slot(). Two
>> parameters
>> were swapped in the calls to atmci_init_slot().
> 
>  The same sentence is repeated twice.
> 
>>  Their values
>>   
> 
>   ???

indeed! I reposted a new patch message.

Sorry for the noise.

Best regards,
-- 
Nicolas Ferre

